Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B518C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:50:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87A2660F94
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 87A2660F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D02644B0E2;
	Mon, 27 Sep 2021 11:50:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uSwwq7aJ2CZH; Mon, 27 Sep 2021 11:50:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F744B0C5;
	Mon, 27 Sep 2021 11:50:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EED94B0A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:50:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQymA81osx5p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 11:50:53 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C23D406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:50:53 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id u18so52828774wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bD2SU81ByuO8RLJO5RDrMC/8VFdSNtKnthXXLJULzNc=;
 b=KPdnEoeTKth8fMdTKgIpFSy869w3KC5nA4MquQVHTHDJxdBR+mmpeme/Bio+k5fsct
 y2gPk7IU4/ekMyVwex+F4Igu19Nrh2wt6I7SyCvDTksgnK629UvITvv4bAX7ih7lcWRM
 7vuLfw5Ud7dNIApDLbNWlF1iGhWp67OsxOuMh7y13EiDfuRQB0XZ8i4wNWXULuygFEXt
 EHU0OkVvFJrwiZ6sBCasDhCoxTGRa6ctE6Iif7gQjbrBo3+p4lXVp+mNIZDYSD2h/McX
 oDXAoGzI0/emAX7x0ZxznathRbF+53ohnySmo1yOu+MF275OQKIHA4Wyyq5/+2uDhzJ3
 mf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bD2SU81ByuO8RLJO5RDrMC/8VFdSNtKnthXXLJULzNc=;
 b=zG4E3SGplYw8+7NvmlJvguWAK6N/SY7qNtW1O96eHDJVoIPaSm+m712pW7bZG8Kp+8
 zX8LEyNdaOe6YgkHVX9VgpuDftSI0gjp6iRkevvBILezPiMjKaoNl0Jjo+sFIO9leaUj
 fSOTiR2PdkmaZjJI+Uc0wY23R3QaRrCsdyvw2FQwMOnygwWDdcoyXWV8ISrfgtTKu2E2
 zNDn1NL9uYOLzS32gGCZD029c/14mGbOgfSiiTi9LaSEx0TBTB79Zo8tnmPaz2l6rlYO
 feucaaJKcOEwiURv8UpzZIqwbupUdvYj1ELSy549sW3mf6thyuZVn9w8MA+xM63Ds8jt
 v19Q==
X-Gm-Message-State: AOAM533jROxDrwZl8IxBaD0SXnw2GzEN5BgLQWlNtJgweXBHb6NK13Xs
 yKU+U1KcNcpEj8+lSxSgjxbVFw==
X-Google-Smtp-Source: ABdhPJwk7UodlbcmeCXvgKd8A7K3G5BMhG4Ur82WbOKNPVZPKso9e2mYyfKX7AMU2xjSrywlN10B7w==
X-Received: by 2002:a5d:648f:: with SMTP id o15mr664308wri.338.1632757852232; 
 Mon, 27 Sep 2021 08:50:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
 by smtp.gmail.com with ESMTPSA id 8sm6619875wmo.47.2021.09.27.08.50.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 08:50:51 -0700 (PDT)
Date: Mon, 27 Sep 2021 16:50:49 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v1 01/30] KVM: arm64: placeholder to check if VM is
 protected
Message-ID: <YVHoWbPXSHt07Ooq@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-2-tabba@google.com>
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

Hey Fuad,

On Friday 24 Sep 2021 at 13:53:30 (+0100), Fuad Tabba wrote:
> Add a function to check whether a VM is protected (under pKVM).
> Since the creation of protected VMs isn't enabled yet, this is a
> placeholder that always returns false. The intention is for this
> to become a check for protected VMs in the future (see Will's RFC).
> 
> No functional change intended.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..adb21a7f0891 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -763,6 +763,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  
>  int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
>  
> +static inline bool kvm_vm_is_protected(struct kvm *kvm)
> +{
> +	return false;
> +}

Nit: this isn't used before patch 25 I think, so maybe move to a later
point in the series? That confused me a tiny bit :)

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
