Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068E8C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:57:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 730106108E
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 730106108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E106E4B0DB;
	Mon, 27 Sep 2021 11:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZV5Z3CQ7KYIA; Mon, 27 Sep 2021 11:57:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9044B0C2;
	Mon, 27 Sep 2021 11:57:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6844B0A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:57:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ME1u7VF-VB93 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 11:57:54 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1E29406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:57:54 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id b192so931885wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JR35HuKzGthWvmv9CEqJPefKanPo+GUZ6dckwUpLigk=;
 b=gih3EnHFCTKeAfABxRU6h6OIaW3q6XxmnJ7BB2hoX0s9KrPfdg/GLhAyjl1bGNr/9E
 +7PDztufqi8UOCdexyXc2otuZIynneBVwdEz3bQFX2f2C1kmNsODnwN5y2rPtJ0/Wi+i
 TNIKY6HJjSeFhDvJUdUaY6F4eOq/DqKG8wWgg+p9ggcm4B+aFKpdJXxEPPXC7IIm0FDL
 UUXOFGU2nfYtOlJw+rTYRI2Wtq/XfOXl2fzP6ILhLQ+RdLKbahBjx3Mxn8PCB+EkBgc+
 QO3saRNehYAIwCEP8oZjJufcp7lttIx3YvfLCWv75QDRiLUAJeYg3/s8aWMN/Y0Vrj1a
 u+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JR35HuKzGthWvmv9CEqJPefKanPo+GUZ6dckwUpLigk=;
 b=sbESMscol1nAgTRA03qrNAHag9DNwZuFV/IZUHo36Vjk82yzZ5irN9dESAI/ms8l/p
 EUk3iLZpyrIXKBx5GCM5nfIfMseT2UaJnvmk/dBGGfJA3J0Nk2YgBQOCPzYt6GPG7wyJ
 0X84jg1FESnUKScKsiIwVHu0SGDbtXf+FwCmrYSFetZ/CKyLzLyGSSNHbZRxBQpLrNDf
 je0kABoUCVmte3yOWTdmfe5FoY2RAeV4zyEexxFSvEdJ8SaumkT/oJzNnDqMZxe84T8A
 ElaQruFKTLQZtS+OhLSoWztaC+b47LsCGhdKMdA6ZPD8toxdVjIbKIhZ9H5BYvj4yEfi
 t4qQ==
X-Gm-Message-State: AOAM530olFxNg0QgO3U5gE+SPl+Tcw9857E6qlEpdsFwZKDwN3CKsY4M
 3ND2E6/sP65ch0ZdGKHdQ3v4qg==
X-Google-Smtp-Source: ABdhPJyRdPlCVLYtYfKxxPD3CfGn+QmcYz7W2HksgyRTiXomX+tB+0JxkqXAM8syfEH3XlcesX3ELQ==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr8232533wmd.17.1632758273549; 
 Mon, 27 Sep 2021 08:57:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
 by smtp.gmail.com with ESMTPSA id l18sm682277wrp.56.2021.09.27.08.57.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 08:57:53 -0700 (PDT)
Date: Mon, 27 Sep 2021 16:57:50 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v1 05/30] KVM: arm64: add accessors for kvm_cpu_context
Message-ID: <YVHp/sbRuCYyroz5@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-6-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-6-tabba@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
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

On Friday 24 Sep 2021 at 13:53:34 (+0100), Fuad Tabba wrote:
> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
> +}
> +
> +static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
> +}
> +
> +static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
>  }

I think you remove those at a later point in the series, do we really
need to add them here?

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
