Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAC649551D
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791371624; cv=pass; b=XqUw16zmhHc+n0JwDEsQhD0rQlBkLzVN7GruaaKofLJRM5zc1dnAdS9Fd8hUeDILdlcWAzyKsoO/QWUBsaUrOH0bNPgghClJc+ma4ms8W38+ivSI327rR9wQ4B/uAIz8bF4vXvB4H6Uq9KfjsrehdbisMwxO7/kQD1AyI8aYCXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791371624; c=relaxed/simple;
	bh=f+RisWKCQLZOEfrvNgEfr/uIKD0wCzcM3ghzQdvYe+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QMdx0407k1iizdMNWQKF/PwWBMzLyL5c4z72ew5N/rO4j+nobZ0MDWx77V++c57b++DI7se6+sadn4+Wi0kMO8vTFqsBMRZ11ITenYs69gtWcF7Br969UcqMWGEmyqmVQBidsTc2Id1mXLNHNkXWW74+ol9h/Y5HfOu2hORtBfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q2TPnXkJ; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q2TPnXkJ"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba40832934so5802e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:13:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791371607; cv=none;
        d=google.com; s=arc-20260327;
        b=KazY9f5yt+p2LPHoWRPWiKSdrXbYX4PwvI3tM6DMmvjC5nhILmrTQ68Hecy8vEIF1Y
         l59rsm8JDgfjxGBS4/Wu9aYDgmPgqMJmT4OV3tsJZ6cwsQG7zZttfv5mgwnGWfaxYrmi
         v92NG9woEZC6kwiE1D/pabdc1x2AKhfDV/xXhjSk7m/bOYGCmNwmIZwBPdMaYmEKIQRF
         kZQEPUq62BpYTirxapfrij5GSfbcrjKXymUdjzAuS5c7Znge6BUVw5Wi1XTy4/kgJM3z
         kWNMlV7nHX3TAsOfEf9BQy9hqjsMN7Ez6sgz68os1JgJdipfr06A1gPyyUDdsNIDcNeJ
         7auQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f+RisWKCQLZOEfrvNgEfr/uIKD0wCzcM3ghzQdvYe+U=;
        fh=0N/oADiEfsB0RhxWi+54y453jJ1aCOXPpPLNYw3GsB0=;
        b=oYp+fcaJroYHhVizsTBP7Zli0Eh8Efrnw1/G5QJCBtbuQMZRFGAs7znraaA0WV3ON7
         PTpBZ+4s3smivqxcPwMmor2ORTJVJtR2oMGexFOjqNZn/rKvxSFc4f0CROoa0nyTllfw
         AIKtJATany+i5JagZho/dn6x3FECfEXEEMp51X99rsoMCbGfYETITPTDdp5D3BceHS9M
         9l6upfF+h34TUhZER9GryBIFrx8FXZp/nTw7q695BsupnjMVWUIzO9r8bHsxCuFLagpH
         M2R2r4j+Z5JBF9SJ/tDNViuh4v3h1BEi6SiR1AYEer/7MqvnMBcAI2GWVz95pudYopKc
         6/7w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791371607; x=1791976407; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+RisWKCQLZOEfrvNgEfr/uIKD0wCzcM3ghzQdvYe+U=;
        b=q2TPnXkJ7KvltQQqtUrFoyPDFMeqYHyEoCube1MRGpFNMbrs/juEJDr64DMHO/y1DD
         AiNxXUniDKyngxy6xtrx0AlnLxNk2R/7wvscmDGTaxnwtyUQUd8lc4F8T1fh4CgeaT2w
         XySYHkyixjfqIL9JcXbXyJV9yqGLvB7Ob8oKkfko88MaxExxx4v38TNv5RKb2DpMOP/y
         xBc2zFDOBGpwS3Hd5NcGxedJFoslidX2TR77yWX5V6skDansBm51dDbch0cg4PiIW9Mk
         EXNtu+H/J2gZx371VirkOt7dG+7Hod8Hq4DMFzJBdyaHqryVQ6PCyMJAJuinqjr6Y9y1
         GGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791371607; x=1791976407;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f+RisWKCQLZOEfrvNgEfr/uIKD0wCzcM3ghzQdvYe+U=;
        b=cJ9T9SY+UJQ1i5RZE6pjmo/4e1styn8gb07ISm9f3CmFzIAhnLfNDgBFnrswPXY1Nn
         tA+ddKvUDhDdjY6XGKpPebLAvsZaWTEqiXacsvgDabLPPggIvYjd1qaKhHPawv3LsdAs
         7ShbxaPFDcE/Co67uerHsnUci+rm8kps+hOaSZL8R4RcHBsNjRFz/w1az3zkFHXNL3PQ
         h8O/JudWHlt3YdDcvTkLLKGCKwK1BBd1WohN91k1XoISIwxYb5R3ulJz3YtisWMoqfqW
         VTuPMZJclkS9PKARQ7xDQvEsKzvG3WPv4baIIu84SYxJUdpM3HvOEEVh0tb/XQI01zpw
         vUQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxj8i0ucHWGlaHPoTjdRFlB/V/+sORZZwJscWR4dp4xj8iWBoZxlyh1OQ64NYPLht57HB+YK+U=@lists.linux.dev
X-Gm-Message-State: AFq9FYLPUNUc5qxJfm5oi0Jzj6IwWUwQjOLDgozkq0j/Uch7LG0ZifwX
	bVGrECtVG3CEDdeDfeP276hfSCfV82jVVscA5YQku48JSQhbkyJOyNfgxY4p48lPrT62oQ5wIcc
	v4abiLvd1CoCeEAuTj6bTO3/EvGFkM6knkVfYyr5u
X-Gm-Gg: AYBFou0pkQpJuTo97kyUkmN/U0ijSI5mS8dXevm70SDIdqfBjBtW+dtP5HiPWx5+HVu
	CgjBm3AiKy4pQTlj7h9bOQintbynk7WXUSAwqoAp73DIY9sqY/bfylSveO903i8YiBzEUBkIOQd
	41wQhMWRPt9P5+PALEGgyXn540v4q4L1ql4hm8dy6ECnyNw0EiEgPoLwI2Q7v1JPg/GKEZG7Fjg
	P7xTfyPfiwNPbWAZOZE/acbbGRvXVOF5UMqQ9m/3i8Pehp6mxsly1lnV9eB+Uh5zt9Dl2Hov1gT
	k2TE07KvRomqbE7hRSoTx61zZCBwN5lCEat+a1l3MfDnfJGlUTV4q/HNx0wC+wjD/A==
X-Received: by 2002:a05:6512:135b:b0:5b8:f142:cf3 with SMTP id
 2adb3069b0e04-5bcca65b3acmr273089e87.11.1791371606791; Wed, 07 Oct 2026
 04:13:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-8-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-8-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 13:12:50 +0200
X-Gm-Features: AclHuK8WLpu77qQsvdg4MDduFoR68Hrl6zUyd6Su64I0GC1JFRH6-dZAB7pnQNs
Message-ID: <CA+EHjTy2WuCui_O8sYXviCmgLQfZ-j-jOBQqRY9NOXzMGQ5k+Q@mail.gmail.com>
Subject: Re: [PATCH v23 07/14] KVM: arm64: Refactor the vcpu_load to allow for
 VM specific callbacks
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> To keep the VCPU load/put handling cleaner with the different kinds of VM
> types, we are about to introduce VM specific callbacks to do just the right
> thing. In preparation for that, make some refactoring to add the change
> easier by mainly feature specific configurations to individual wrappers,
> so that different callbacks could reuse the helpers.
>
> Adds vcpu_prepare_mmu()/vcpu_put_mmu() wrappers to load/put MMU related
> configurations for !pKVM guests. Additionally makes it explicit that
> kvm_arm_vmid_clear_active() is not required for pKVM host.
>
> Add vcpu_load_pvtime(), vcpu_set_wfx_traps() wrappers for handling the
> corresponding configurations.
>
> While at it, also make it clear that the timer loading constraints only
> apply for the VHE.
>
> No functional changes intended. Based on a work by Marc Zyngier.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
