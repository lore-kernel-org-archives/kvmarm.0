Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979CCC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:08:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31FBF49EFB;
	Mon, 14 Mar 2022 16:08:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pGX91gJajN7H; Mon, 14 Mar 2022 16:08:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA5C49EC0;
	Mon, 14 Mar 2022 16:08:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC574141A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id isxuOryhtJiG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:07:58 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04B1240A84
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:07:57 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id l18so12446603ioj.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5/64AAEf4Vzs1A/LiRdwPiWTgC6wn0RFoaoEGIYS0K0=;
 b=qm68+ONcoiq70dlktTbSNWbKZczAYgBGwZhIZ/TCBXLlcnEgoXErDNKwxkmfapE/54
 PTEL1lKRg2IAH7cVdEVFVAvCBmewE0HrgTTPrnMWrHk+MPOzMIw5rUXPmi8Y5/H1gRez
 859U1z7DBPH6FPvSI0hvnipljJ4ADXURCyDlTeYJmNZ9ebJs4R7l4K5MVDF42BY6TNIT
 xnH6CcG7sUGUYNdTJ5r9lM/oLxYYKhu1euBNh51o+Ui5s9E2bmfqEsICS0yQZ5cEw5sf
 g0b2C3UITVh6uavnGAIFFQ+ncGVq4H6EWgNjHawb22qaRmnDZpwWrAOtZSZOl/X1NLJG
 K0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5/64AAEf4Vzs1A/LiRdwPiWTgC6wn0RFoaoEGIYS0K0=;
 b=mprVsyVMJdjOQekxrwVmaZydv6A2agGWk40FHeuPM8zryaAjwaDZpzH1iGbyQTI1+O
 RSWcb0TGODIEb/yPJFJ7nEjyuHO3KT4TQatuqvmuQXiOTKXoQPO/BmVGCh5eOAR1dUbR
 bE+h5X9DDP6sEn+CdQeSbQRHkEgX7oESMXN9lKb9BmaDUas8bNVibP3BhiMnjuNhRPKl
 kePx5ewQma3/qcBj+BN+ywbNn+rl1XRSClEvFChTeyexrunDTaRPA3WD4GNyHLFr8CJF
 MpmcRHVzH5pFJnIHXAkbDC/ZAkPV6vZvVKVvCNAKnVebbQHXJIIOattBiMVPUnyO5jxF
 k8zQ==
X-Gm-Message-State: AOAM530qSF+K5gR9YQqVVsRgY/eO4025hGWKdLmzAjZYBL/aOqZMSMYa
 Dmjo7EviHf3QHyb5jOsKU2vYMw==
X-Google-Smtp-Source: ABdhPJx+cCT9RbztBLcxVFaSRxxa8KxO45I5CoBY2KZENSIpHruKS+BfdUba5UJey30qxO8YNS+AMQ==
X-Received: by 2002:a05:6638:1616:b0:31a:131c:9079 with SMTP id
 x22-20020a056638161600b0031a131c9079mr2603879jas.89.1647288477157; 
 Mon, 14 Mar 2022 13:07:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 b25-20020a5d8059000000b00644ddaad77asm9076916ior.29.2022.03.14.13.07.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 13:07:56 -0700 (PDT)
Date: Mon, 14 Mar 2022 20:07:53 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 1/3] KVM: arm64: Generalise VM features into a set of
 flags
Message-ID: <Yi+gmV6xuiCkAtbh@google.com>
References: <20220314061959.3349716-1-reijiw@google.com>
 <20220314061959.3349716-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220314061959.3349716-2-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, Mar 13, 2022 at 11:19:57PM -0700, Reiji Watanabe wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> We currently deal with a set of booleans for VM features,
> while they could be better represented as set of flags
> contained in an unsigned long, similarily to what we are
> doing on the CPU side.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Gee, that's one popular patch! Just as a heads up, I rebased it on top
of kvmarm/next in:

  http://lore.kernel.org/r/20220311174001.605719-2-oupton@google.com

since kvm_arch picked up another bool.

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
