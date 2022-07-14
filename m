Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEC3C43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 18:30:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34DE4C489;
	Thu, 14 Jul 2022 14:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CWiYFzbUCtKe; Thu, 14 Jul 2022 14:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E1A4C499;
	Thu, 14 Jul 2022 14:30:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 666B84C499
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 14:30:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tk3SdX6+iSUj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 14:30:23 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F47E4C46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 14:30:23 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id y9so2579535pff.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4BAm5Ap7NEHod+fAr+PGt31kGD7Q/EnOAXwYki9v/5c=;
 b=BCA39DCEAsKOKGBaqJR+l3QYfsmgwCJi40VgRFZwur6EN97IC7Kg8h2PQiyvtVNJpo
 wVF+zEhTF4MR3XQFSuVQ1vLJFSdPbLxr6Ej2tyO+cP5ckyNqDiydQD1Zgm6BkMcWJ5LR
 Z0SFYl7hsMAIyo/CMkAvPa2fT8Q0KMiiQHHG3RaPXVfWzzvgvNeJQ4fk/9L2OMC8OZ8A
 3fBoWitDcLIJnYHWfjkdr+6Xz1c9CueCZ3sMoEWzA2CtVvQea+Ct6fEo6+yQop59R5RN
 /1sc7hXyTwlL25l9n279LRiby4xwLFS2vzgNvgAAK+/KsrBFdbROM7wDRqcIzsFnPqD5
 T4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4BAm5Ap7NEHod+fAr+PGt31kGD7Q/EnOAXwYki9v/5c=;
 b=7mFfBLq8NqNpDwk8qjQG/luRaYcZmEydTJu0X57oVdlbvuxZ9Z673quPX6QA1kt3cC
 SiwFc+Ncfobs0ebs5//GIqz9TBHFWbb1GDAFNQJKNWrVzS+/F2LmeK8bJc5dLfzlOmft
 du11YkpVUSkCZY4MB2cnVLEk+egDIfB9V1bKTG6hMPuouNzKpH9rgsLO3wK5xMvCCH5z
 Unvsk6F8LcjBAvXh4eHtDq/Cnbn5qcSAMfmj+ajWjlqCrd6oJlanXBupavQ75iCZyvzT
 ghkppEke1DBYrjnrM5eT7/q5GUU1FNWVNVMS8Pzs+W16bwdeSrcNps/pGpZXHyIMsbAh
 hTVA==
X-Gm-Message-State: AJIora+yj7veHHlIgS3Q5dj3kcroScRT0OTFALwe5OWwJwKHJjA6yZrU
 k+okA39tZoTK7O0tnnpj6sV6Jw==
X-Google-Smtp-Source: AGRyM1sjxrHT/mbe4M8hvqrXQIDM4yXuUm7dhZKaRkKzb3JLGDowQCkR2H1I24UmOaD7DJvIAA+U9Q==
X-Received: by 2002:a05:6a00:2481:b0:52a:d50e:e75e with SMTP id
 c1-20020a056a00248100b0052ad50ee75emr9845998pfv.43.1657823422034; 
 Thu, 14 Jul 2022 11:30:22 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 186-20020a6214c3000000b0052ae3bcb807sm2009028pfu.188.2022.07.14.11.30.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 11:30:21 -0700 (PDT)
Date: Thu, 14 Jul 2022 11:30:17 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: selftests: Add support for GICv2 on v3
Message-ID: <YtBgueWEevIcS3EO@google.com>
References: <20220714154108.3531213-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220714154108.3531213-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Thu, Jul 14, 2022 at 04:41:08PM +0100, Marc Zyngier wrote:
> The current vgic_init test wrongly assumes that the host cannot
> multiple versions of the GIC architecture, while v2 emulation
> on v3 has almost always been supported (it was supported before
> the standalone v3 emulation).

Thanks for the fix. This was my mistake (also I was taking too long to
send the fix).

> 
> Tweak the test to support multiple GIC incarnations.
> 

Nit. You could add a fixes tag:

Fixes: 3f4db37e203b ("KVM: arm64: selftests: Make vgic_init gic version agnostic")

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 34379c98d2f4..21ba4002fc18 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -670,7 +670,7 @@ int test_kvm_device(uint32_t gic_dev_type)
>  
>  	if (!_kvm_create_device(v.vm, other, true, &fd)) {
>  		ret = _kvm_create_device(v.vm, other, false, &fd);
> -		TEST_ASSERT(ret && errno == EINVAL,
> +		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
>  				"create GIC device while other version exists");
>  	}
>  
> @@ -698,6 +698,7 @@ int main(int ac, char **av)
>  {
>  	int ret;
>  	int pa_bits;
> +	int cnt_impl = 0;
>  
>  	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
>  	max_phys_size = 1ULL << pa_bits;
> @@ -706,17 +707,19 @@ int main(int ac, char **av)
>  	if (!ret) {
>  		pr_info("Running GIC_v3 tests.\n");
>  		run_tests(KVM_DEV_TYPE_ARM_VGIC_V3);
> -		return 0;
> +		cnt_impl++;
>  	}
>  
>  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
>  	if (!ret) {
>  		pr_info("Running GIC_v2 tests.\n");
>  		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
> -		return 0;
> +		cnt_impl++;
>  	}
>  
> -	print_skip("No GICv2 nor GICv3 support");
> -	exit(KSFT_SKIP);
> +	if (!cnt_impl) {
> +		print_skip("No GICv2 nor GICv3 support");
> +		exit(KSFT_SKIP);
> +	}
>  	return 0;
>  }
> -- 
> 2.34.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
