Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283E54D6C34
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790951866; cv=pass; b=M0/vlKBQ+CQC5qj8GRrdKu54HWGZVhNNcBMbL/VoCBbN2toeSk7yXPsNWw3peQWMoD2Tz3fS1TJAkI/uNdalVdWeNF7j6HmX1Flb4ciJZZziDUa0XgFiUmfMRuXZIA46kGU/X8AC3TeUnQxBfYt+aIDUHndQL9hBvuVwuE0tBAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790951866; c=relaxed/simple;
	bh=bvtdEPxwSQXjnHdQcA79svDgXzwZQykpi2V56CMH9Ps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bSOk87i0PB/sFXivPubpoKwEOkHOeneQO51cDUyuLRkms40RAxiyO5zYN70b3TbM/twL7LogwBE8Bfvxu8kbL7pxZFIx1DX2FCsTfopsmF8vLwBlEAmUMYwtTvzdiabl/QuqJ220YqqvmONZwDUIVFY/Wu8lHMY33+108129uFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R1xqvz3k; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R1xqvz3k"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so6656e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 07:37:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790951857; cv=none;
        d=google.com; s=arc-20260327;
        b=VJJufMi9nhYLXVB7q5mnxlfEs/eZPGe+Sgs7MQGEy5FLmwiOOEbsxlm1EcqpgpINcn
         N/cs0ZrgJp5MHwvmdbytY+Ck7wmkF32qZyRI6GG9QIQCLT7xvxOawhL9w8h9UAaq2cgb
         HQH11rmm1PiLXoAiI6QsBjPsUs7YzxDlXowRAi6TW+PMadChvaW5tT3EqvGparKYtV3f
         WMxBxAVhYwicP9tykWtlD5i4kZZZqLG4xxhuLTuSG3l/yjUxL6hFltVHokEa4nMHuUcB
         pLaMDZWXejp7gDKPWfxGa0SWP3Ea4EFIQG39c55V+hMlFhM9DQclT/sXaIPWVvkvAor3
         zzxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ngc+Dc6mG5eMUNtbuXMSrmBLpP8pJzc9TOtXps7kTTo=;
        fh=1v9CtvlPQOCo6BiNK7DXXYhstz5fJLloY6Xz6PFWz/s=;
        b=H3ag9ASbTYblQg5CzhMSzZ+ttvWH/bci71MbGOwbbmcg09ZySDcTz/0BP0e/5Nx/nD
         Se48rELXdDn3Q/x9ECZvQjZxvhy5orT1HjcDtQRgfit0N4vUD3vphnKNAr75ptJWDkOm
         V087YUFlRmWlK/wPnlgaaVDiTEThSi3mie7rLixk9N8+S3tEOnolgAez1dniwM58gQYD
         henYrGId3jREZGh0dNO48qvisLrBPMi84/eI+U0VLleT0jnfYuex6Vr2B2nf1uUi2ETl
         U1ttpTxGlQyph583rWokA+Klc2G2Iy/dVfDH3dbLOn5UAIG622w2yFt/BVxjuuf0wMDu
         2SOw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790951857; x=1791556657; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngc+Dc6mG5eMUNtbuXMSrmBLpP8pJzc9TOtXps7kTTo=;
        b=R1xqvz3ktffT4BMo/9L5nlwbU9edHygbQvrl2jM5PHWzTRRRcZEfpIfTGjsB8yNaKB
         eCyDu5OaMQtglP9VfYyt+mol1MwnbkEx4D+bVkoRYIDUzxJyzN/4S5HoSnVW5MbRfY3a
         D9zVYpHp9s4xyKMrJ79lQNz7A1iTfWooBirJG/q+Nuy1SO9iO6Vr+CtTIny7RhpaBZk1
         F9/jwACWqI3tmgFzAI5wfEVwwMSG6bf5JwDJQHzNgNbDoEplnuRuT6A2DydcQ63bGXXB
         8K4SWVQ+rndZe00FOIb14pZlpumSsAJstVwMS0yy3gBr0Gf+CWz+nQ1BhrE/Wgf2rJRf
         7VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790951857; x=1791556657;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ngc+Dc6mG5eMUNtbuXMSrmBLpP8pJzc9TOtXps7kTTo=;
        b=hBknTBEdPrVu6/MsZoAtG3HTdHZqu9adQQ2rTIK9lzjtcOJlofrKpZhqFVPzxVdDaC
         VRk9b5Mbt1uvCz2hvaO4gyWeFIGKyMj56/h3XrTljT3eyhRzbPpjCO2x5he36crvATl5
         Z2JJUYyqqVgafHCKihiIVDkw2llBzLcKHK1FilXfLnFw7iChl4QXMBhWWCP9dl1sNTAg
         ffEr6uKTEK1Io/v3z2Ztv87F1rrHdj7Ao2yk+6ahaFdCcI79z7zHLJsxo+VbyoLYb+cO
         rh5JymW7Ng1xFevMNoVZhNyKiCxD/OLq4e0VKHlJEXJz8/BeUSyFiZrpd5gScKjiDESP
         Zb2g==
X-Forwarded-Encrypted: i=1; AKwUvBz/Yq12QOZt4TFuJeXMS+QtKqFpORTQwV7wSMQdqKr/CuPljeVT+mJ9qLBSYJ6uv+qjbeauZXg=@lists.linux.dev
X-Gm-Message-State: AFq9FYLvFIABi01owvtstPLlJuqKyoFC3xQRJVUpKYDbddEU5ZiCBwsm
	F7OVkDZ31diIrfURAF0zZubkQcyN1Tfg+yYbIz1RDYPdKFB3Dgk+gcVbBacIVzpMotRAkYIB8gP
	tNO3g5JwT2ClRzcyiPrjI3auwzZoPz02bpF7hpm/w
X-Gm-Gg: AYBFou19NR+itj+VyWlMGeXKuq6y3a8Dl8SkKluRXMadb+NaYKO8nOJSaqUzHU79imO
	3Sqs8YO65gPi1vESG0dUKkQ/EOvYYLE5+GLd06A+r3fhRdECIiHeBdYC802gHaaRkTL38yhadLi
	TCj/sN3/M2BS6BA6jimZLoyisNIm4hHmKjm5sypeWFYYS2TmK/UgGt0zDJiAAAMKaPWq/k5RAn8
	Kd65J/XSenkxDlLVXyvSft/Nwr5Fh6EIEx0JZBOD+djbB8SFPwYMXAj5xetunODVc3/ap9mlagR
	x0TeoAhUYZgFIY4gx938FVvETihS52c6eY7micJl/eEd5SmyyKTXULsB5LdZuxzbfg1OeHFADzw
	bP2lyT1IRPq8xSg==
X-Received: by 2002:a05:6512:3da9:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5bbe07ff87fmr127412e87.8.1790951856416; Fri, 02 Oct 2026
 07:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com> <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org> <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org>
In-Reply-To: <86pkxs2npx.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 15:37:00 +0100
X-Gm-Features: AclHuK_ts2oonb5gFFEThD7Rzb_QZk1ok5N5MoHVdkKoZ33EulrV9BUtxD17tPM
Message-ID: <CA+EHjTy4rb+6z0bqh7sPqACES0EDpURdeoyiFGmdw3p0PENcOQ@mail.gmail.com>
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 02 Oct 2026 15:15:06 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Honestly, we introduce the flavor stuff to make it easy to match
> things on a particular VM type in a readable way. So why isn't this
> reading:
>
>         if (vcpu->kvm->arch.vm_flavor != VM_PROTECTED_PKVM)
>                 return;

I know this is a sketch, but just in case: that's inverted. The sync
only applies to non-protected pKVM VMs (EL2 ignores it for protected
ones), so it would be != VM_PKVM.

Otherwise, looks good to me.

Cheers,
/fuad
