Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B24DD3B0
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645926; cv=pass; b=N0nLkOB9oOmfxWaau78muPv0/QVv01Npwx7hSFpnyFfLRVdloBhS3yM9gwk3Ze1FeXH0IrquvcGdK++cS2pMbp88oiSi0ntQHlPoX93hmfxEZCBb1lerImTm4NqyQArF5IVrzt65eNkap4gaFpfKIaIsNvEiuLV2Sn3qr7VoHBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645926; c=relaxed/simple;
	bh=nOYhv3codkqkgw3J82tO/HjCMv9eP9bGCd7SuCfawsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsTHm6hnHf38uJwq9HzWK1D82hPIJBmikz0i6sIvwMPNZjv4HNX/R9EOAPnKcOJHAeqnIuHfXR+5joNoRP6LKneFrx54WieJrtNdQOp7xBySArTYvuWgnHMwmNF38I/DC0A+gx3XB1Jt23GGLciu1NxV7dWx0Rbed2SU0aUTCrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C+apKge3; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C+apKge3"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so1048e87.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 04:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789645909; cv=none;
        d=google.com; s=arc-20260327;
        b=gATwr+ybOB56ItfyOW4sr5AGoT81YPpGLtU1N5X6as1m4xwMSiO+2AJyGvoeiTZwPu
         awC/WYlUqztsin28nqMdl9gybvXno6ZwW2VavyrQ1Deds/Y09vdey30EhgZ9fwG/Br16
         cUz1npmA1mPmB30QzNwDG/V8fy6p8kmsbh+kIEmrv/E3OVZI+OBW8kRtPJkNY5KYXU0o
         DhhUJdqDyfdfP6OtJ+uhozq0xH0YhMkeZn68PsGawyt2sarFxSYr0NffhDM3dvEp+S6E
         3dX1DYZX8bmCHpWXlb96118dIYCu9ANPIGOrNwpIsbnIdv0nZHA1MAYM/sefzohB15pX
         LVyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AdIwW+5qYXXR92NXdwAH/Idy+Qhx8FbslhR3tYZnWQg=;
        fh=i2TiysWnbp0nT0AIAaXEcebZekv2wbUbb+Omsy7ZaaQ=;
        b=P4t6zK3gn1oyW8/aeSG8vk6+4yPltC0BZKHtLknj4DSygnOVoNJUqjHRth5fYVRvii
         XxDb4r4Nkf9pGuaxZYtfS521Kk6nHTrfVPoRbTf2FZ/edvvQF6RqWbUKx6DRKsvaBM74
         hZD4V1jTts3z2xczeYyVkVagbdGhek7/vNbmLz12J1c89GaEYq03wzvoBEZaM8JQiYKE
         kD8f+WUzt3MXRfElK24lkvEtH0kC09EmV/Q3GxyK/F4g481Rac9d4vbLj7wjdhqCSG8A
         7N30FT68EcIjdue9VkL5MRNFYqZFo8BCdJ70s1IgR5L3i7TN5bdj5t6NiQwq1vKS1eXT
         npGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789645909; x=1790250709; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AdIwW+5qYXXR92NXdwAH/Idy+Qhx8FbslhR3tYZnWQg=;
        b=C+apKge3yhajv1PVAy5GxKYLPg7Cbcge6i9zCVYWx9UzWijVRLP3xal9cdVAKh5BcK
         EW1ef0BNeDmHiztwyv3pu+92HbfIfxmOfb1E4JzKBXKRWgFA5mGl0G82CEayXLb/+3F8
         yDqBfr2noKQ4/gKC+n4oY3dBiUlgREEbcJKLalkAFekZDLx7b/Tg6JyXsCvDyo6lEGpu
         hwCLttbMIdXL8PvEWzzGsauYRZ8Bl+lnFhC4896EiIyGd+fOFQGsBiZY9zamHSJhbhVr
         wKGhXERbzoHgzL1T7F3afPyw5slKKVN8hY/6moPJ5eKu7yKmlgjVQmtHKWyzTA2+EMcy
         WzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789645909; x=1790250709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AdIwW+5qYXXR92NXdwAH/Idy+Qhx8FbslhR3tYZnWQg=;
        b=rTiRKu8fB9RmK+m5bYidmsZfkw2QPQEdTVAUp+XzDbmgQmrPTXT4PH6fEQWokjRvOa
         ezaDeFVWYuNjYerlKW5jDxTHttotn93SpRmxeY25vUts3DSerAnPut9MnY+MDpJKJbGU
         D2aOMU1WqMHvzv7jR5Mg7dXMjNZ/3W9DMFwzCWhZt+WsRjv+JHje6qNkUwbmHi2qlJUa
         EwJSxpi5XqFs4tGt3FdjQdIm0lXBfmZ1hpWXnuWsgA/bKKK0mGT+jeqOfs76tYG+dEnq
         3ejTFpGJ0WaNiijFWbtrZ7hZVpwGm2eDtLnsYojJw1gy30a3SjsbwVuHG0+4HH+IWa/X
         drcQ==
X-Forwarded-Encrypted: i=1; AKwUvBxCjTaxmiCnKQC08SssUpdyI5tiJ+TGNPybBCCU6TcGf8ElEz9XvDmKAo810DMPNqOavnLDdHM=@lists.linux.dev
X-Gm-Message-State: AFuF++kXKSIZF14rMtzqR7m1kckoF+YLTVSJzcR8OKFycu7A9+oXtqlk
	BGQXRFPgAok+1AVSFc6ae+Oi8S9qF3ABv0lpo5ZRr6IsOEYz3mXBGYXZMbjabuAEJorfUqRXyJF
	Fy7MjnYlBeiWINRqs7fQE9Dq9cXdlOFG+5EehZ7zm
X-Gm-Gg: AYBFou2v/FGDwWIcAGmTOtVo6D7vTNnqiAfGriRBjQASSARLm6tcBhdGuyMyRhVJJLB
	jVMCKFjHVfGvKfVWn39BpCs3Agd8kN/CYd4pApK5iE44/n6V6CbTo2l57HMrkR0FuVwClz1ECt+
	WgzXR8by63g4h+jiVl5N0adcAanynXfVJVnSqA0D5SuvpSpow6R2/AupH544rFhNbNV3vxNM2CL
	9SgaKUzTVEtao/b2P5qYmdXiE3eLYn2TopnSz3JJFY8jteFgDNkKQp/eKg6exEXjta0RFqBL55M
	gbmBIOlswDQfkuicOBJUIXoDRdFB/4H5BEgzbBr0DHGgYWySxV/xEvcxj5dKsozGucN8h7Wr1HT
	ASdckzHKso7539Q==
X-Received: by 2002:a05:6512:33d5:b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b8bff20394mr25749e87.5.1789645908458; Thu, 17 Sep 2026
 04:51:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-13-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-13-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Sep 2026 12:51:12 +0100
X-Gm-Features: AcwNN1X5WP4Na_O-dNFd8fWbgG-HeOkWBxaHeAYarJjcpr1hEP0fkdn3TrX09z4
Message-ID: <CA+EHjTxfbG6-LPjJVoErQ3iJk4vAvhVO=Qv6hjcxDXL0yByiQA@mail.gmail.com>
Subject: Re: [PATCH v18 12/23] KVM: arm64: Widen the scope of "protected" VMs
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 15 Sep 2026 17:01:30 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
> -#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
> +#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
> +#define kvm_vm_is_protected_pkvm(kvm)        ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>  #define kvm_vm_is_unprotected_pkvm(kvm)        ((kvm)->arch.vm_flavor == VM_PKVM)

Agree with Marc that this belongs in patch 5. When it moves, could you
add vcpu_is_protected_pkvm() next to vcpu_is_protected()? The pKVM
host-side series [1] has vcpu_is_protected() checks that are pKVM
mechanism (the vCPU feature allowlist, CPU_ON against the pKVM
power-off state, the ONE_REG rejection after the first run), and with
the wider predicate those have to carry a pKVM-specific name.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914113338.159227-1-fuad.tabba@linux.dev/
