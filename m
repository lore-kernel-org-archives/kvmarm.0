Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BDA39CD04
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059834; cv=none; b=tp/1BTbOxyi/VEHUIP/cmpTGKR499qmoSeZFwQvziTpOKDiCSRTTU/Ig32M/9xAoZ0W1RHy3BREaAkg7W8HFuTT/Kk8yzWkr+9V+y+Ct+N5osjvqtXxM5lkqTu6UqZ6Q4QAS0DutgfVaTUT0sGfn362tkYJYEDs9eRqJKTNTrVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059834; c=relaxed/simple;
	bh=sVnVFGLfReg2RKeoIZ682VlIKd99aJ7tnRlIOx/+zYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CGI10Ry5W4hkDsQd+q3HHg7PHrTYwuTwDDFv8ID52biQw0E6GmUyC8smqgD7kE6oaa+5LntHwnFZd0bhk1FY08NXjQoquuanoYplt3BLJwEDwVW0KGwzcFcTakVAKRAzHbiqoLrwO76k343oEjVQxFp7ctZ8WxMXCO8G8iMVsfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tu8QSplp; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tu8QSplp"
X-Forwarded-Encrypted: i=1; AHgh+RqN2T71gzF0YyGD8xBDR4IZ+JfJLb5pSzEf9zHVQnRTCanlLK+Qo/l8gc4v3ngcyzie2f3TEs0=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cqlSeCpwocQEmK8jPueF1yCbKiDV3dojuJhXPMIV//w=;
	b=tu8QSplpAPmpBpq8Sd9vH32RHwuJ4y1Y0bd8tFTJ/ABZbkWQ6kBqASXmqKF5mbvc2fGz0a
	OML/SGUZjOpk+2TFAff3DHIpUtnMKgpfpCE5QYL6+5ugyB/ZZ/quSm2urmyAphbJOeklzr
	ySLZ012XsVoDT0RpuRIfBCs5YGVhSGY=
X-Gm-Message-State: AOJu0YzZUbNz0tosocexzfbW2mBwmjYfmbyy99Za4v4px5TaLhiFXgop
	duOxHFtPxtxRVgwdcSTy9nlSvbnS9eKhavCo6G+s+nzNakLrJ7UlIV4enqAlv8d51IIRYcpHFcT
	gmj1shTgYxdU2wR6VbzhVdBVquK7zIkWQE9QB3Sbs
X-Received: by 2002:a05:622a:289:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-51d7bcc96ffmr17653231cf.7.1784059812809; Tue, 14 Jul 2026
 13:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-10-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-10-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 21:10:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzm-Nv_FaTGT1-f0tx1v4kYVaa9LcfNgvEiQJOo_nyF3Q@mail.gmail.com>
X-Gm-Features: AUfX_mzBFXy0D-wOkq0LD_Ri-IqJu87749Yb0iJ6-50K_-aUHBIcRFe2rotbFjY
Message-ID: <CA+EHjTzm-Nv_FaTGT1-f0tx1v4kYVaa9LcfNgvEiQJOo_nyF3Q@mail.gmail.com>
Subject: Re: [PATCH v2 09/18] KVM: arm64: Add reclaim interface for the pKVM
 heap alloc
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:

...

> +
> +unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
> +{
> +       return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
> +}

Missing new line.

With that fixed:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>  static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
>  {
>         if (pkvm_hyp_vm_is_created(kvm)) {
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
