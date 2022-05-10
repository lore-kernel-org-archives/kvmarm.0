Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECFCC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 18:07:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA5F4B1AD;
	Tue, 10 May 2022 14:07:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yZf5vcUepJQk; Tue, 10 May 2022 14:07:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 037A64B092;
	Tue, 10 May 2022 14:07:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62AD14B092
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:07:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uFNcJCF75Kpz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 14:07:38 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74B7149F2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:07:38 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id o190so19379201iof.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 11:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=K3yjKVlbFqZ2m0ikf7GP7NYwaTPazPuG/HX19ZvzGR4=;
 b=mvIrK5aZSaEzgccQ7HMZOzjcs65nqUBVWAospV07fGM2jJ25DDn6Uz8bKsg5T4iN1E
 KKDRhziyFpr33N632F6kMYeYI0hzT05J90ElYLTV1HkcGDSHOtFkpbtx/0jF1/BmQ/gu
 AzMKY2XOb93zX9uqcd8N5ZPHnD4C3R/bOG8aKhIBL4WjX9+t4pp5g5G/wAp8/IQ1CG/+
 4cB3sTVFGvWvN+4qgbileda9Co0VKQ3bOxC+0eEcKsQhvaKfLlnb8EfcZoi34P7d/u6v
 HYmKTphBbBqxpvHMg5hbiEsrSALA6SvpndBtT8Uw/IWDzwxslWn5B4dvaNh5Nh9tKHyL
 uIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=K3yjKVlbFqZ2m0ikf7GP7NYwaTPazPuG/HX19ZvzGR4=;
 b=qA4VK+ksl11H+gz/02+JQbyF+q3dxq2T5WZqhrMMt7MCItBUlvSCxoQbiVVKQ/mv8O
 10kWWuRPfnp/MWdxrjwY6uogJ93Oi08eQdyO5GyWcXdRbYfPGD33JCes96uw49fCPa8O
 h1vwl6/OK4eBg13qT56c73T3ovRKAzIaqRVWZ7KVbUjoZgulfYVCT1wn8nk1CtzOkiot
 1CjuLz316OoQBUOvHKOqMeltkSwR1IEvaueUnUQov7mrObLinXHbO0MQ/2Es15O5+hLy
 Zy1b34w/vnIE+u25diPcxBCdmmGN3GyX4UnrelM+8D966Fqdkvdqj0RqpJTpgxb/Y1Vz
 qBGw==
X-Gm-Message-State: AOAM531SzyTKfb5i+rls5civg8vhqPb13a/WHKFt2CNIojpRMnKuLimZ
 Rpuu3y6N/r0KK+SLDeFed3AhqA==
X-Google-Smtp-Source: ABdhPJxGS8QvTjZKL58nKrvkOUrP/UikCcTqZWe3Hajf/PkVvwSx7CuLWX/jqu4Kaec6IClFGyeO/g==
X-Received: by 2002:a05:6602:27c6:b0:657:7e7a:11f3 with SMTP id
 l6-20020a05660227c600b006577e7a11f3mr9418017ios.40.1652206057295; 
 Tue, 10 May 2022 11:07:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y8-20020a056638228800b0032b3a7817casm4511095jas.142.2022.05.10.11.07.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 May 2022 11:07:36 -0700 (PDT)
Date: Tue, 10 May 2022 18:07:32 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64: Reenable pmu in Protected Mode
Message-ID: <Ynqp5MKvpfIGolOQ@google.com>
References: <20220510095710.148178-1-tabba@google.com>
 <20220510095710.148178-5-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220510095710.148178-5-tabba@google.com>
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, May 10, 2022 at 09:57:10AM +0000, Fuad Tabba wrote:
> Now that the pmu code does not access hyp data, reenable it in
> protected mode.
> 
> Once fully supported, protected VMs will not have pmu support,
> since that could leak information. However, non-protected VMs in
> protected mode should have pmu support if available.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
