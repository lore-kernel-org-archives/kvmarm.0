Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4849C4C9
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 10:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540696; cv=pass; b=MbqInBY7oxrsDcqsiyECkao+8GJTB0owjT1L0QJdOL43I6mwr75CBRmHXIgtZNjeuH+AIhmch3Gf7uuqUWjJ3AyW3gI7rMeDnKlH/o7jcYbScxIqOmeosXDYRwobihQO6uMTunLFUvL+kX2cYBu/gwXZ2s583hpei0QiwuSxhiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540696; c=relaxed/simple;
	bh=jO2JB94/A3Hvfgi2+EqsO7+q4h2Kbsj1cn+DHY7QLyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFxDnLM5jZ0CsHW2/58ZMeElrhotpf2zUbImrux0fygaZXLg5kZ1ulxP4w+o30BoLFxTsI62cETl/LdDKXvWr6VgIKQoqBOsyov7p3Ox50H5hJmddRzEsXa/JWzQMPEW9QZNCE2pPZ/08k/lIIszGOZJ2JbA6LVafhGekhgpzP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aPT+upGu; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPT+upGu"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6868e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 03:11:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791540692; cv=none;
        d=google.com; s=arc-20260327;
        b=XKbjclzQdq3pIZJFp6Eqq8qhfW3NdMklMXmxbN3Elc5F5/ff6LM3dDnvJMJyk6ZzEo
         IZfJxiA8A9+lpQgPgCfuY4Eie0TSqoycpnwKilnGZqg+YtpObgz6B3HtrHT0Kb+rJlJh
         rspbOo0ooqRemJP9FsKzzny68T3aOo7mMnZkcoPbrPaYClQvIMbvip+kEyaYZ3nYUpnE
         R7qFKw3eBOAS5uO66NT6+QMRBKdpcDOZgqcNNNz2+1u/fQoKRjA20a2Yk2FAc3tODvtg
         DWwdVmqtqBxd67qdk5b6BMWTyWFhNiyeGSRbPkdstLEVUFV3hPANC6h1t1JtI3sKJXdS
         As8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X91Ea0i/B9gu1Cdd3wVY7vcLKA2e9/BIdZO5hwAmvwA=;
        fh=stkS3rRFl5+jFAqMZm595+l3nhsXv4Bpc9a8G7pzMbE=;
        b=I6bpSJGbKaQF2+qk4z0vj9V9h+qUMCF5B+Kij//6LHBcjm2cUZFMsBrhlyyrg3fVFQ
         b112xbD32QHH0Xx1/z6d2JBeAxAOcrAfkHxFupeP5KYVBCD5f70B/F73xAMmsDltZuhd
         56NoIMPZL13HkLOAGKM6HM+RTM8J4/FHr8JZlwlTLFcD5JxINfDNULwDM9hBj+yB5qyq
         p8eEXkihFcv29+mD/uAf0i0OFZ+4RdyU3HSrxjEpre9wqn3D3LvyT4VMKc5gtWR4AzJ3
         3ZBFKcGB0psRAutUlPkqtt0/E4AauI7Zl5lQFUsjpHb0zEHxp7FhVMRTuZhMn3mIkWfR
         kybQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791540692; x=1792145492; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X91Ea0i/B9gu1Cdd3wVY7vcLKA2e9/BIdZO5hwAmvwA=;
        b=aPT+upGuOZ3DCgP0TB6ThF6AjLajXQ+i+kHVc5s7CSn1oYh8pS3mTi6yq84MgRV3ix
         sWp5vJvKkyQ/lQ11HQnSOhBdI4enWmMawBRfdaYYk26+zeK7cbDT7h9SqQnolXaVevFw
         Wq37Ddj1b3Rj4e81l6FRwezvuJWH42jxXAoelUf9fLfME5zmjLvMIJviAVqSphugD95M
         r7y6v++8nvTQbRdohHhHa6JbO/1TzAevJftVfxkpe54XyZ5VCTvLRXGAUXvL68597VUR
         Jr+72it4M8Z70RNkUMZGXUSAJfdceKkYNntKWxJCm/52RDSSkZLJMtl2UZQq6UrFKMrW
         gNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540692; x=1792145492;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=X91Ea0i/B9gu1Cdd3wVY7vcLKA2e9/BIdZO5hwAmvwA=;
        b=JWSsd4u+aWWv/EMoCwCOmSU5SwoR0qnWVakW9IfKkmaLz1JsGmrErc1fuGpuDkqmKN
         oLcRgNAWoWZxEvO4NnjuGk6y4dHKIbeKIf3XRqd7CPHIz9MhXSdFCjQFgfoGbKjtJdAL
         n6/kCClZFfY1h5WKlxzHWlHPS1JDaJN86huuPUpOaIssIge72ZHiq4tAfGGZhIUUl9GO
         3dS1y7j7k1wCpHUW4+2OnEZiQKyc9tUgPmUqxPFKauQLO4/bCj2c1GuUSps9i+NphkXB
         EDtvESLSYOHkcXb73KhPUFq3xSIvXwfbUPfe+cjORdC9DMRuR4DJtBZT3oCZoPN1ga6w
         x9Xg==
X-Forwarded-Encrypted: i=1; AKwUvBy2rGNaSn3g+AFQ59dfzWiTAG2xp0sOdO3TJNRJj/pCcMV4cZYqaQn0Wke/UTSjLo0AqOzNpFg=@lists.linux.dev
X-Gm-Message-State: AFq9FYIHVFqFBl4p/5ZNsh/kDvnJ8rA+rbHBA5i2kqy12ukoRv9qC5Yz
	PJhcmhT3hFcO8+gG06KZJ3FQnCpa3tdEEJiI3MJSXsD93xeqPqYa+LIKX3BSzI9y1w+wbhuwQfN
	6F0C2oyjaIjVVk2bY8DOhojWHLZx5M94XjFNHqGm2
X-Gm-Gg: AYBFou0FfcOLfa/nRTBzgyWKMOOJ7J/UriSPmXWu9APrtR3TebM6RkG1kcd/33IkpwT
	lgZB6QiVQkt6bjSAJiL0qN/kRjzsswBg//kiqw80HIr6NosJYooNioKvCwq5b5X4/I8fDNEdly7
	vXXSz8ytoc8C1luMaXN8necNct/CQwp5sXvaR/APK3x6z/VEGmlCGheb1tyrwabghAfJ//Ut93s
	uqsPX1peQJmmxN/8oKRzfX2RqhgZSa0SXEkLMtHeLJZ9JM/23kC2fyYKKpDHeuxojdGbOYRcdRH
	e6BPkAkrlsIXK5RDJUNphYZ5cp1NS6KchBOEcixuD8lrDhXnaZNJZWbMYiKQv8xWaRZlrE8MDo5
	ZRAZJBsNJpbGasA==
X-Received: by 2002:a05:6512:6619:b0:5ba:4293:fa55 with SMTP id
 2adb3069b0e04-5bcdd5286e0mr89466e87.3.1791540691538; Fri, 09 Oct 2026
 03:11:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-15-suzuki.poulose@arm.com> <CA+EHjTx-niYPnnRDvAAiY3MXLpSYau_PhiBTCiE9mOYUChASPQ@mail.gmail.com>
 <86a4on2qxz.wl-maz@kernel.org>
In-Reply-To: <86a4on2qxz.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Oct 2026 11:10:55 +0100
X-Gm-Features: AclHuK9LIRInATLITNjOUiJu1KjVGIe10ULmW_HxdmRBfJcwxXlgGARzP-Th6tA
Message-ID: <CA+EHjTxZM2kEtsG7+pq7zygA8Mhwzai9PL7+ex1K35BPVSt6hQ@mail.gmail.com>
Subject: Re: [PATCH v23 14/14] KVM: arm64: Prevent unsupported vcpu features
 for VM types
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

On Fri, 09 Oct 2026 09:55:52 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> A rebase would be a terrible idea. This thing *must* go on its own
> branch, and not depend on anything else.
>
> I can however fix things at merge time. is something like this what
> you had in mind? It compiles, and is therefore perfect...

Yes, that's what I had in mind, but please keep the PSCI 0.2 check
from kvm_vcpu_init_check_features():

        /* EL2 implements PSCI 1.1; the host must not dispatch as 0.1. */
        if (vcpu_is_protected(vcpu) &&
            !test_bit(KVM_ARM_VCPU_PSCI_0_2, &features))
                return -EINVAL;

Folding the allowed set into the mask covers the rest of the block you
dropped, but a mask can only reject a feature, not require one.
Without the check a protected vCPU can init without PSCI_0_2, and the
host then dispatches the forwarded calls as PSCI 0.1, while EL2
returns 1.1 to the guest.

Cheers,
/fuad
