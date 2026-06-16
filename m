Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F435C1BD
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613763; cv=none; b=gdAPpwwUihXRDfjku69/7L7OSLiiVKNY9PA2DRg4PI0nY/u0LgnBduz2eN7S6Nc3xtdMiYgCcHrSsbjs7HJeY6vH4SmGP/tjdoG9Yv1JzJplD/Fr3ILlV0LmdiioA+HxUojL8ar6bmIuV/lsC3qwXByS58h6nGPg0yvZETv7lkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613763; c=relaxed/simple;
	bh=S/14zLWy1OEcuI4mR72n4fdjjZexwK9+L/T7STtQPr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4/7e58q0NsO3/b/vVeuoDgGaYDaDir9xdGDvxzGdDbAdPZpRLc4LOXhzQs9SOzlQWo26qSRiupOjyRXQ4hqxWn/dS2EOeCwfwluWXym/sATNV2rhsnyVqkCElz/xhX/eKUC2LQLd2/iML5Jjv2uAGvCrediBNLt6+Q/elxFhFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L06o2cjy; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L06o2cjy"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec49f7e35eso580597366b.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 05:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781613760; x=1782218560; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KlKBLad2Erh4BtAqk3Be7oRe/1BCOSeCPkKHDyyOPcs=;
        b=L06o2cjy+HW3nR4fo2m4z2/lJROHSIlSuaKcslfCGaJNFK7+4KT8iiVxRSzqtGCapw
         GF/XV5gD72WJaF+6unpHSIoTovOJMmp7F9cb1CpAE9A0Pha3Yy8whAWNVXEJw10z9u1U
         TwIKn0oRf7nnRLqHVjQixCabviZHjygVbA0bAkpmbvsg7hCMt1CrVpVAtnlwrJdnebKE
         BCfz445jJ5USMLTWPBa/7l3N8X4yJ2Z3jgebWxvl6gqs6HF8jEItwlg6gKUzXVg05qdE
         RrhU3v9soqx04mNrwRa122XLOksRzDRFmyIhZNVePp7F/YpdrhnkFh2giQ6Gbu+4OMWB
         kj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781613760; x=1782218560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KlKBLad2Erh4BtAqk3Be7oRe/1BCOSeCPkKHDyyOPcs=;
        b=UnVMmFGSSKJ6hjCt0h/hCZARrLM2BfKBU3aRQZtI8KOwynbAITiSgTuQlyYyOBhgh4
         B2Sdxh0yiGroYIdE6DJVj7FA0AOwVeb2ouDZCDeXhl+3MFMRnrqG9ST9v6cMmEorP6Mv
         fd7jAfueMN0mfyVljTUY/q88tNuR41WiUAcwbtd1izQuBo/FQ2VdP7+FD778ek5eWeOv
         0rZFIt4WHgjslWVh8QDFcpZXhzkIUivvZ8XQbrCaRUNrN0Jo4LuzEYt86Q56eAohjUak
         fFKHDJU0NVLitr3LPqWd3bL/361OI/7brfUbfz/EJpkqwPbk6PjAwkOEoe4JlOXhCvKf
         vxvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fgFQ/NIfgOOdy7pdWKGglAvjzhk/b8UL2sP1J9HJKxuQrW4vW7XyNXgo8Ooh3Kq4WuqH0zoA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRPlHQJ8nGkYkQQ9F4AEH4MfaQG9O8y9MhcIyrcA51aHJ+pQon
	zqntxCQYl+Ug8+DQV2IxQXXK2RdvWylJS8mpH/Cgd7Jxpy0iFsLXJ3XkROoVGbJVqw==
X-Gm-Gg: Acq92OEMlmocRVpdDI4fniea3NuxRvLiabRuQiHdwjAzLMKhYRNirvvvplF0mjFKyJX
	8hBTzf1ASwZkbtY8/NS9p8KTaE4k65pDUV7Nyj/5baEZogNpsvY4Fha+HjM7C4VkqlmQ2sviNVq
	/5FcBxDNMlYi4EZXsoO4gHFBVTe7DeA15ztW1gxuYPQ23xQIj08t7wnQN836GzZ/0nE/S8MMSsX
	o3/O+3eDBTKwF/7h8jFr1K5cfgWOuDC7NQsxrKeUOPBb2WkH+CmXrbz0ihGGck2egy9HGYK7AXy
	c/lE3oQK1Q6Q23erBGQ1KYAGfiQSCxB3Vru4LcXo6H6tDdjCMzfzbrg/+0CmuNW598G0SRt+E2u
	k68NaDIj6RnRLxemzG/ZvxkTstfr13ETZjEjs5rwG+GrGQoSPfOR0CLVB79SpOMGzwo5lu621K6
	2GTNGyv2Srhejzt2UuGJ0WbxO4VWDVSoR1lhGgEL1sLHFTwZSBqCK4FFPzY/nbEdT28Pc=
X-Received: by 2002:a17:907:ab8:b0:bf3:e968:bf99 with SMTP id a640c23a62f3a-bff49921dfcmr500315166b.10.1781613759630;
        Tue, 16 Jun 2026 05:42:39 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb8e1db3esm637694466b.56.2026.06.16.05.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:42:39 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:42:35 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls
 to Trustzone
Message-ID: <ajFEu3rjmWxVKgyW@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-4-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:10AM +0000, Sebastian Ene wrote:
> Allow FF-A notification bitmap messages to be forwarded to
> Trustzone from the host kernel driver enforce checking for
> SBZ fields.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index c723a21006aa..dc7496ec295f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -713,8 +713,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BITMAP_CREATE:
> -	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
> @@ -909,6 +907,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +	u32 idx_unused_args = func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2;

nit: should probably better expressed as a int as this is the type in the
ffa_check_unused_args_sbz proto.

Perhaps you can even fold that directly into the ffa_check_unused_args_sbz()
call?

> +
> +	if (ffa_check_unused_args_sbz(ctxt, idx_unused_args)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (vmid != HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -967,6 +987,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BITMAP_CREATE:
> +	case FFA_NOTIFICATION_BITMAP_DESTROY:
> +		do_ffa_notif_bitmap(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
