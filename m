Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76AB2F3C19
	for <kvmarm@lists.linux.dev>; Sun,  2 Aug 2026 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785690858; cv=pass; b=fjdrfVIKBDgMAAPgr9cF5qEN+UBKY6UaeZ/BKVV+Cu3eFF1Rd6JFRCG5Y68UCy75FpCj9SEgIIjNrQA2n1iP1Pcjmp6nrhMn1td25Dp/njmcB8bA5+pgnR4FD6BPb1karRqlH5SJHo42uhYQWPGP2ANAan28ErPqYByw9DEh7iY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785690858; c=relaxed/simple;
	bh=N2zyrxlsrzbBS4ipiL123ByJSRIJ5EIJvd6lzBD9ems=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glo2Q/+9U03gyrlFFQMNLIYj1LspqFuiKFITydJa5ilhOLN62VKYfnk+UB5DF5gmfQk1M4xbN/VRHc6x7pAJy80Swo9R3DUOT7SwcUjBlWPMBaXt00uogBrZuTpY032Eo/IXX+Ac64S8xCtfHizKlvlgpiHpg3vo8TbS7u6ITvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bBCH1PZz; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bBCH1PZz"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c15a5b265so242091cf.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Aug 2026 10:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785690856; cv=none;
        d=google.com; s=arc-20260327;
        b=f5mRIHW5hKG6ogtNz/8izqLgEjUZc0OxJbofxe6S+6SZF06hkr57kMxberK3kk15V3
         tvf3ccaWgxBY54LQocRQ/cjA5Dt4+R/3GOVjB5BIDxmAaDPY7w6QBN/QJ34LwDC3r05B
         GVSMRf/jtmuO/ZscFQ84juvbJrLcg/keFPTpibgH0z8d5Cn6PdxddmZhLtxjiX6f2dxg
         KZPNDeBPQ2Ar6sQbTjmbvdyX6p5NePOU3OB9konDsyo3fciTPn+e9ESwIkZfsL5VQiDU
         zbDiW3p/xFbhWWtk9o4fp8M1yxs8MN3yogR5gRS4EHeEaqzEZToOkhNf0ZsJe1Y0jx4O
         2ZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ayuvivxfWK6wLmGHo3e/3r7UFNU/ARSNtwtuFILdC94=;
        fh=DQGXn2kahNVYKi1VhBXjEtKNQrPuzWi1RE2dJETb768=;
        b=WTUO3qdyXQRgNkiYOPZZonfwf2aealBaXE2RHEY1SJFbTXY0y1bRoUMondiktZS0un
         CdUlo40ORalpbnaNfeC0KF/MMfbr3TA49MD/F5d7pKb/y9bZFqhfS1zVuIfmJqEHZYO1
         neFaB/a0gds8SfLQfQ9PkEQVW+2vScfs3y+frcqYaCpUO3r8OQvzhFVLB5nbpWPgbSkh
         kmw18ZHTQeTRjfBhI2f5JIYAFs05wWgb13GlzHA+SjDN1ReThrrUl9hnuFCMTcIK2hqw
         JbiirBB3Al1nIy4l1uPnC/mdg9i413o9rZuWj6j4ErieFDRs2RSLs+QnSLa5pPOs3lUv
         C2Lg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785690856; x=1786295656; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ayuvivxfWK6wLmGHo3e/3r7UFNU/ARSNtwtuFILdC94=;
        b=bBCH1PZzergYK7zlpo6iEOvJTiBKq/eV29GKhGDNj5gs/nCywSeV6ak7jyIk/7pjRW
         W6DCO2QdQBdmu49IVCXNf8nQm25XGitRtTB2FnsJgsTdJImUVapLdGBDxTKMAhCoPylL
         IYWdia5OzmoXEoSV2o++UboIETJQmZmjKpdkYPPPtfIvTvOlgTgdWG0rf6lVL7+EHWhJ
         xmjuGPZsiSSkaf9YEANsH3iRrozgkJyowDDU3V3qarEXjMeycFCdDv/PF4U4B/MOt/6s
         5P4LzMNre9L2bZioYeIrToEy1K6KeTUg1KniA9GWVtKe/q3nfo9MDdpnW1nG3Mp+xYYx
         S4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785690856; x=1786295656;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ayuvivxfWK6wLmGHo3e/3r7UFNU/ARSNtwtuFILdC94=;
        b=dZ3xecFoXrnFwM4yENvFVJ0lvrtugjNqT6J5RNffeEeffQtiZtwNRCtc5oddHVk9le
         mQmKKdN2HfNNl219uxy+sncBb5BElKIbWXNaIJi/5Omcq3CsXgKzvp3ZINVbIpDw/jg/
         zYIj84MvO4djM3PFEQKJgBooymMc6zGwlilWxNc0ne8pHQrJZkj9XwWwTR6i2WTEGuyK
         JQy1DlX93e+iI4do7uLWi/vw4VMJ/f21dHZCCxZjTQj1ktpSmBO+oY98riADP+9ffLCo
         0RoCdRxfYJ3pYkQGRfSEzNIEVmI6kYiVISbR11t6ukvZHhz7vbLlSmqBYDZIEKRNhzgF
         0tQQ==
X-Forwarded-Encrypted: i=1; AHgh+RqeYRkpV1yP/ry03beY38OzWfsk6w7AkilBYSGp+t5FEavdsAH0ZwcBxtRX2VY6F/KXyG/wtJ8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMDvDU/Zo+//lZxajmzOh8+hRmiAfcI3az7CGHfhEkXEG14jQe
	Fz+aVnycpQ0+MAt9BkKGEuIrT2ztRcgduZvKcVPU/5LAEdBv7IG57iIMTbewp9AfJmv2Uiugpk1
	tnEYnhqfeSKQT6nm2ojh5ZQySdKX0OYB+JQeW4zS7
X-Gm-Gg: AR+sD12AAuF+fVdNHUcgkxZSGlXdu/wXCIOTXdDwP9Q/vHwJCmW8ku0/CGJleM4xwEC
	gc6jNLTs53z14Vxpn20t1F8b6dEQyBb9+Uk2+C8wvsl0Y4al5yggksZg3gKDRix8xz45pTiPQOK
	tVCfMjxHsx8Caqa0BqyDKaNepK3n2pTNH3gmAsG7NhBkhqgeIyH2mI9fL6npjoIK0a5b6520/PY
	nncTHeqG1WAPy1NSqBbbyb8/q5SbbAzkp1WjCuujAW1F71Tc+neWpDqN98AOIK1fCGpMm0m+1e0
	wtVO0NUNOCjKPl+yhOJ+PR5pqc7FTCWIElDxuD3ocFTs
X-Received: by 2002:a05:622a:306:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-52b598d2377mr25182951cf.2.1785690855240; Sun, 02 Aug 2026
 10:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org> <20260731-kvm-arm64-idreg-final-v1-2-3de2a5616dc6@kernel.org>
In-Reply-To: <20260731-kvm-arm64-idreg-final-v1-2-3de2a5616dc6@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 2 Aug 2026 18:13:38 +0100
X-Gm-Features: AUfX_mwoTQF8U_Aj2r-8-_EcZtVNirbPZIAEGO6l1nd6I3aMRbsfn0JxvhrYexY
Message-ID: <CA+EHjTxoAwkUJ1Tyu5700hZBFtc1HpCt14-8Gh2O5qA_NpnaFQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Block ID register changes after we rely
 on the values
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Fri, 31 Jul 2026 at 21:46, Mark Brown <broonie@kernel.org> wrote:
...
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 958d7ef78785..3b423db56d3c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2427,9 +2427,10 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>
>         /*
>          * Once the VM has started the ID registers are immutable. Reject any
> -        * write that does not match the final register value.
> +        * write that does not match the final register value once we have
> +        * got far enough into first running the VM to use the values.
>          */
> -       if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +       if (vcpu_id_regs_final(vcpu)) {
>                 if (val != read_id_reg(vcpu, rd))
>                         ret = -EBUSY;
...
> @@ -5811,6 +5812,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
>                 kvm_vgic_finalize_idregs(kvm);
>         }
>
> +       set_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &kvm->arch.flags);
> +
>         return 0;
>  }
>

The flag fixes this. One consistency point: set_id_reg() and
set_imp_id_reg() now gate on the new flag, but
kvm_vm_finalize_sys_regs() still returns early on
kvm_vm_has_ran_once(), and so does the KVM_BUG_ON() in
kvm_set_vm_id_reg(). Could both move to kvm_id_regs_final(), so one
predicate expresses the invariant? If so I think they would need to
move together, since on a retried first run kvm_vm_finalize_sys_regs()
re-runs and re-writes the ID regs via kvm_set_vm_id_reg(), so
switching only the BUG_ON would trip it.

Separately, would a selftest for that failed-run path be worth adding,
checking that KVM_SET_ONE_REG on an ID reg and KVM_CREATE_DEVICE both
return -EBUSY?

Cheers,
/fuad
