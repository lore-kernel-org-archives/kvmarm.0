Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BDE48BD47
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808894; cv=pass; b=LFLKQlB79y3cl3EveUDN1aXW12/y4/FpxAfMUBsTF5D9CKUpMS4f1513dnY9qouxcDgVRskv/2E6gP89NryBxkrW4xjGucoBddaEOk+YKIqMeZHlc3mvYw+kz9/0/O8Rrs9c62Oy98HjJnHXi0glz/MAujfEkatVcZgP9fraqkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808894; c=relaxed/simple;
	bh=VfKCPQVOUOpn+HSkPidkYxQhgan5ZPRfgoJ+H6ULViQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AeVoMHdeqXaYb5PGCqgGwQqUEHAuTy2CKZ28/FY7eEIx27SCKrdxfkOvIbzv3QbvDtLoGq3p324GoxLr4uGv3b2Yts9NW86Z7j6VLo98S+hAS0eVfvLJbq1kKL28n4PXahw4K1ZejBHcBnlcJObWuv+kiyWHbd3Cz2ZBFzxPTxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8w8Sj9l; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8w8Sj9l"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c01c79467so242121cf.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 05:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784808889; cv=none;
        d=google.com; s=arc-20260327;
        b=Eyccd2rc9vPdzgZhBzyDwQm74quChGduzlxRNYbKPREbOR9Excw1Nn3edRRvJSd5GH
         Eut6IAnOsHL0nHZGW9tMoRlhjwvJq6obKUyNGQAEYcn9eFmaTB3bHJJYDyOTZh4Fu5Wb
         b41OwwOhT0Z8JvzY6jCCPE47djr4TpCgzBLRFxS7T5JBzRoIuwpHdCzF16X0T5P+V2VE
         PfTSOLeTjHjEjIzePuvXfHD8ldyWYLueEmqQbOdeRW1wF1RgGaqhSS8iZTsot/RwPAF1
         V8C0QaGX/bZ10AKfln8An829DlsZuU9g9Dg4Mn71jk7zhUcxeu2VDWlKiALj76kCUWJn
         7W7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CiRRBGhgo+/JNW8LKBdu7urL+eWjfJ9C8Tc+eH+pijs=;
        fh=K41QfPRFZ+IFYsHDbilkVXTyeo3kiDqN2ORUxFKq2F0=;
        b=c5LwOVOCorKwwZV3trHAR748hgqgt3gUNnbPmp/CXuhuZdA1UKpaw74kvyTiNhILoD
         vekXZ02tEyKcbCygKZxt8e5TstHvd3iH7kIA5+nT+QgtauEEoU5PngDoKCCbMkRd+UUX
         YH7IvuQmrZ7v2Q/ciGRoDD7DknFhI2ggCfaIJXe3/wBWTktYPGwvH6pk5/gLUwClScVO
         S3nR58A/OHz2dpGbT7vow7d0BDZv/WyYr5xQLUfP309vXYzgVDCd/3he3130le3OgkzC
         ZH80PCPlGmZTO7CXwAFF2BUW9/nZBsUY/VsnIEUqE/WQ0HCzbfQv53gM2fmegxiJzRj6
         dVNw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784808889; x=1785413689; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CiRRBGhgo+/JNW8LKBdu7urL+eWjfJ9C8Tc+eH+pijs=;
        b=N8w8Sj9lKcnMrws0DBpf+/wOYaINZeQPYHByZoB1pISBJQfEvlUKkazIhmFGIEPQl+
         +OnW0IOcFkljwPC3UTRNLZm+8ycJlPeD2YfqOPpEd6TZWCq35N+k9OW0qbcq73yuD8G2
         wikAULRXC4HeMLCa7h4amfzrGBOsFk1KZkEoI71dWx+c4APmjdX4oXP9hYs67khcXPnD
         wptFdHrjQPoyfknsieSztUrN10nARAb3INTIycu1i+3950CtQ56SZBarqlrPRiNxNUc5
         X6Kd2frkdd34trF9b2MqmRuQqhhjqTexDzvGOTZM5IaFnMQlSEpaT07koapAPKaPDnEj
         enjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808889; x=1785413689;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CiRRBGhgo+/JNW8LKBdu7urL+eWjfJ9C8Tc+eH+pijs=;
        b=YUikWWmr2VHQBas4S8gdKxFRGLuiT+XvKUSYIRvxKIpVfGqStaFrBKgo0gYwJ4ZnI1
         JPL/9TXsAgg+nenuK0ce2ZO9+Ex735+bNpjneHCpB3UZ5gYPmDWDcDzIuJtcwzC6nx6K
         YumfMRc6xd92x6fDkk/tPlFqLOzApc49oo3lTxqBHAcIkG45wCYiIlyxWenqDoQVh9mT
         x2wC7/tmcOFRgEX7tnFVI0lIccejzuu9SEUwv9hLI0QaNWzXaBy4BcdWCNhlim1S8gFw
         YiDurl3CPLrcSGsOu1bwosJqLXZ5mfkv3Sw1HySR9lhTDzb/gAUJxTdg3jH0+4y+DP8M
         ps9Q==
X-Forwarded-Encrypted: i=1; AHgh+RqwoEVYhgo6H89g8sElAlZUJFtVhpQTli6BKUwDRzqTu88x7XZObiGMHjYSFGkUSGluaRkSGNg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfZdxdO/4iIrc6jAQbdA2FjtYbIRvSZK1UDz4hOYze3Jr7b0aD
	tLMjAgUdTYsYaj5FIPP7YpVLuVpWw8FJqTvy0TSYuBM6beJaPvxh2yGoFbDudzegkq04v7J/1Er
	zxitkXWu0jTyUgGVinh1S6E8hv5v9e14nGCzMAOop3pmgYCBo5kEM+Sn5
X-Gm-Gg: AR+sD1216VUYNP87KFpBUJBUcob3MlS68e8ReO7Ims5+ny/PCWInrykYJFwia41nj31
	1rsAiek+A7MQsNSL36DCf2dBdebt3+jmAM5GWVM+3BGRT8wnLDQyfX2HII/3FMeTD2SS1O0OXsX
	zkHNtOHBBSSpzbn66cCgxMwa23FxXI06IA5BLqNiYRl6BZIct2ffPBD5/HWzi9eIMfIA5fvhfFw
	ozD1t152vhe9BTxUZNTqH+B+ivJM6MMkz5RVjJDqw6zP2Jf7L4aW2cwIj0PIHH678q2siyX
X-Received: by 2002:a05:622a:aa4d:20b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-5283bb02792mr9318891cf.14.1784808888595; Thu, 23 Jul 2026
 05:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com> <20260720171513.1415357-14-vdonnefort@google.com>
In-Reply-To: <20260720171513.1415357-14-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jul 2026 13:14:10 +0100
X-Gm-Features: AUfX_mw7x-tTweQMnMrY_kzHt22RrLf9Q-xFkE3Gv6ElRLMYqmF515Q8iWNUSK4
Message-ID: <CA+EHjTw7t6KHuQwktNN5_dJgZCxeWejcoQMz3pe6wUuS=R+QtQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
...

> +static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
> +{
> +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> +
> +       switch (ret) {
> +       case -ENOMEM:
> +               req.type = PKVM_HYP_REQ_HYP_ALLOC;
> +               req.mem.nr_pages = hyp_alloc_topup_needed();
> +               break;
> +       }

Sashiko raised this in a different patch. This turns any -ENOMEM into
a top-up request, but hyp_allocator_map() also returns -ENOMEM from
the pkvm_map_private_va_range() failure path without setting
topup_needed, so nr_pages can be 0. The host then handles a 0-page
top-up and the while (!__ret) loop in pkvm_call_hyp_req() just
re-issues the same failing hypercall.

This might not be reachable today, but could you make it so that
errno_to_smccc() raises the request only when nr_pages is non-zero,
and let -ENOMEM propagate otherwise?

Cheers,
/fuad
