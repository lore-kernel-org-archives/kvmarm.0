Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C6312832
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710001; cv=none; b=GAiZ6F5razul0pIWtdV0F24IRe8h/SsDsqUquNiMdb6MdjR4RSFGmhcj06/70Xi0RFdBpl4D74uzdIgkwHLdLJI9nDpybZB7lPW9+wnQS4KvvAfBcSX1zMui8z/oyPJcAQX6ChU0O6t1gQM+ZzJ32U2vA6yZKyoqq6lHhZSk8p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710001; c=relaxed/simple;
	bh=l7WOGqpWt6BxjM82YQ6vvWce52FE9wYfeNAc/9dcLZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdEkMBWQ1jPby8e6jrKgwuU7dhy12TpMjCORAoVGrBQjjgBR3rxTLQwWXwdZJW6vJy0+lqm5NCQqTwbYNuXcZnqOFGM9dnTLWtBdPI6YwHyIRqtK9ujid9k+FyaASh3cliDS55Emip8zSy0/SJa3sjlxmKBUQT2t/XY3kPQxv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gJ7XoV/b; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gJ7XoV/b"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59b6d1b16dbso26850e87.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 06:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767709994; x=1768314794; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5AMNcthQygf8VT+liZ8aNL8DRneL57jGS877Q1EimZA=;
        b=gJ7XoV/boxm/Fd4uqoRvGTRyS0Tp3yTjN4muBVnEV3PcdRIe2ycHA1GCXEF3K7UZ7E
         XV0fDx0jWldZdnq/eLBvK5rbLzDFV9tuFZbRbXDlDVAclmJzdIOxAUkjK1/Ty6nZ3XAT
         vZBo5TPTFVPoto/DSa8OG+A1nUiXMcfGtGWV3QUG1l15N+DNt9DFJINN3PxBPJuOrGAJ
         1CsTD618liSJyp3fe2AVaNKzZkdCwyNsYykzwM7t7Cv9kasiE4S66EpcwxCMmX8hr+fv
         Yfefd79GY3QVl/2enrnmdZcvKheT2YDg7DYgDVGVyDGpr0AFhalOh8yflEV7/NtNdIg+
         IZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767709994; x=1768314794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AMNcthQygf8VT+liZ8aNL8DRneL57jGS877Q1EimZA=;
        b=l6krVePV+m5H5q/p1RaBIiQpijmQWDlmMzATzBNeZvCCzKAZ8nooMGmvVQ0Yq9CiTM
         UUxNtymWEossQRiY05laZHpcD35//ULPio3npwVNIlU78yX+pG20XY6Z39WsA5XLELwW
         qQf784XpppXqQOaNReHnfwlyQytyVcgxE3bl5Gz+JqVra4aZsMGs2daQE8lVe/jvlNOm
         FQuYeuqtBvScSWdyD9DrJBugbf1k+MyY3Tbyb+NljOCZIv1Vg4ouC2n9kdg+1faospuJ
         9DF2IzuGm0U4AYwapVgaaSRVDSi6t3ZVL3kkM1j1OleEy06zcg4Fs8pWedxr4caKCakK
         dJTg==
X-Gm-Message-State: AOJu0YznGBHXwv643bun9kMGPVr5XOwONO4Poen7iCWI8j2bfre8f9o3
	dEKjZw7ABY87qLHkiSvTapY4agBjxmeSaF/767PYydsuCy7V2ar+utUNwekE4qMrbw==
X-Gm-Gg: AY/fxX71MY401oA/PWP6cBOLudjmZt7XzA8aN713mOF+uR3fWAo/LPEwAtYrAxinGhe
	jVZTwZ40YcqsgRo8N3UORZTb+PYGD0zJWx4rEpPf/MXaZqSQdIzsmRI9+e1MYQ+XLF3SCvlEzC2
	ZM1vNKwfr9vcEtXpY49oayPvQL/2+O9Ujwl0TNtIVAnPhfiSrPMcLHdoCuGio1wIWh6iOzFPzm6
	W9mVhLOhkJ33+xlHMAb0+Z0M1OKiJRsAUKJiA9g1/aAjtQXWkPorEZjzFmTT0/6CXHMWSb3klrY
	hYvFk8mxF40F/HEpFAjblsp0lPkrRgSMcn1zr24Kl42dEFFIJXB50FJ3RxoPv1DfW+L+ZhlHzex
	ydWld6Bv12S6YC5/GeHjVfjoG+aXbADblygmwRWx+b9BoCXctrAeJDX8cwQSwFg6Eeb4slK8MsE
	SD7JkNAx2mc7m+ve5rHhx2qkVhSHhYoYZ3wiHTRKZAv9oa7dUVM4gTjf8h7TI=
X-Google-Smtp-Source: AGHT+IGm9/zDJUuH0cbylnpYxHdBnRrcu5NEEpA7nyYc/TIusHsYonshe+9LSiZdmjF0EBhJvVNLEA==
X-Received: by 2002:a05:6512:2383:b0:594:5685:94ce with SMTP id 2adb3069b0e04-59b652cdc1emr1192679e87.48.1767709993734;
        Tue, 06 Jan 2026 06:33:13 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d69745sm602189e87.83.2026.01.06.06.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:33:13 -0800 (PST)
Date: Tue, 6 Jan 2026 14:33:11 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 01/30] KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT
 to fix pKVM walkers
Message-ID: <w64q53n6zmhub2fbpiloaha7ipydxl7albqvqerpgwxfcfkgpi@a5n2n3gule3h>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-2-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:09 (+0000), Will Deacon wrote:
> Commit ddcadb297ce5 ("KVM: arm64: Ignore EAGAIN for walks outside of a
> fault") introduced a new walker flag ('KVM_PGTABLE_WALK_HANDLE_FAULT')
> to KVM's page-table code. When set, the walk logic maintains its
> previous behaviour of terminating a walk as soon as the visitor callback
> returns an error. However, when the flag is clear, the walk will
> continue if the visitor returns -EAGAIN and the error is then suppressed
> and returned as zero to the caller.
> 
> Clearing the flag is beneficial when write-protecting a range of IPAs
> with kvm_pgtable_stage2_wrprotect() but is not useful in any other
> cases, either because we are operating on a single page (e.g.
> kvm_pgtable_stage2_mkyoung() or kvm_phys_addr_ioremap()) or because the
> early termination is desirable (e.g. when mapping pages from a fault in
> user_mem_abort()).
> 
> Subsequently, commit e912efed485a ("KVM: arm64: Introduce the EL1 pKVM
> MMU") hooked up pKVM's hypercall interface to the MMU code at EL1 but
> failed to propagate any of the walker flags. As a result, page-table
> walks at EL2 fail to set KVM_PGTABLE_WALK_HANDLE_FAULT even when the
> early termination semantics are desirable on the fault handling path.
> 
> Rather than complicate the pKVM hypercall interface, invert the flag so
> that the whole thing can be simplified and only pass the new flag
> ('KVM_PGTABLE_WALK_IGNORE_EAGAIN') from the wrprotect code.

Reviewed-by: Quentin Perret <qperret@google.com>
