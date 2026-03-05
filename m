Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97623E122A
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 17:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731177; cv=none; b=hyPgN7+4s6yNqUHK8rfdJheG2A5ZqdmmxDcyou+pSTpHJP/+nPVUBuJ6K0C5XT+JGUcIQJf6ayHG3JWYt78szm6iBrr5kX8GL4xJgsigTnmWCy48y+CChJKN+bdDacyYazZoVNf9VowZogHpp4lEq/g1wZX4ghhF+H4nNNiMA6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731177; c=relaxed/simple;
	bh=44DsyPZjR3+ZY9GszCDwqZ3g/HaaKmi7IKLakzXhb6E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u0J7V227nH5Gd6gAG26Dv9W7BecOQ73/9Xypn2ZcFLFmxWgEa8dO6cadbfFfxy+7BtiHPmZhUEPsftC5u11cdmjSI3ypF2Toy2t32ypqk2GVXbyX4OdC+4kYbls/nFbxcnpxVrn50fZYZ08Wr4GZ8Wjh0KalVzcRFIl+H0XtGHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7kw53Ss; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7kw53Ss"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c739120475fso487277a12.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 09:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731176; x=1773335976; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jvL7QI7vtAV/elV7wuwJjb0ouQ5MS/0W571Ri2ejdh8=;
        b=e7kw53SsSMt+893fYb3FL3sSVuo5UDrFozWX4NgI2v17tjwq2cjyKaObn8g6pSiq3v
         mQwVORDZ0AJo1o6KjlEIrjkq6Q/Moq4rxteVOVAzAJoIHZ3gVHc9eN4QSGyHsZxYZpKD
         AssA2by42Jk7hZM2GDosVstR/kJ5p7H4uhWMzm1T258Kcx6QmlFJEZO4QfanMs41QG4x
         1RsB5WW7l8jKbqHCtn+RvKwRsbVT961whdEutaaekfsY9bKEMlUUcYQwnPZL4zLxT5nQ
         molgIvRQ/En0OYJd0q5GadWiYuD4eypUzNGGbNnjyEUFR6OeWVlYql62S2mKpaAMZu5S
         FB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731176; x=1773335976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvL7QI7vtAV/elV7wuwJjb0ouQ5MS/0W571Ri2ejdh8=;
        b=Bzf0cZaXzFB3FaWFQlEtjz7KjnbneyXJ9NFz7hn5gB2l1/faTf6lloUUWwdOWsiipF
         sV3uZeLiCX3zz7uG30X0YBYvbPy1j/H2WU9Jekt+JDo7XnWMbY1JM1ks6E2jp392vyE+
         rj/+29TxzkH1gl+8OjuWcdX34kxw/6QRnfVN2U/kyxyg6oG2VN9TUJLDRpfRckdZFIwk
         7NHxlX0Tv50PqHcDO8N0fl+tQLjCkU/7ExpiAxkM4gAdQ03ZnLPMTxDGjblQek8O0SfI
         hnBDcP571Bu2VEEAORKG74yFkrDUEDdjFk8l4WLfGLWPMHXSmRAUGL0ZYby82TiRHrQG
         th8w==
X-Forwarded-Encrypted: i=1; AJvYcCXF9dpQEUpVUIcsm4h5rjf0oKuVoxmTsjQgma48/FQixKoLH/V6CxBeedf7x21c/Bt+D5kqCrE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm5SGPBNtp/Y9qJFYsYpWNFgTs0Wg7uBQz49VXMRpHJvxKmlQ6
	p9k4lYNSofhtTCDYNGXmd8UoqPGFdpw4T0PAguQN97Kl4acO2VWPv2u0k1pMZEO/Qi6LR2RQ817
	CcPxemw==
X-Received: from pfcp25.prod.google.com ([2002:a05:6a00:a259:b0:829:808f:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4295:b0:81b:d5d9:a83a
 with SMTP id d2e1a72fcca58-8299ae60809mr419972b3a.61.1772731175885; Thu, 05
 Mar 2026 09:19:35 -0800 (PST)
Date: Thu, 5 Mar 2026 09:19:34 -0800
In-Reply-To: <20260220004223.4168331-5-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com> <20260220004223.4168331-5-dmatlack@google.com>
Message-ID: <aam7JsCyQ5Oacvl5@google.com>
Subject: Re: [PATCH v2 04/10] KVM: selftests: Use u64 instead of uint64_t
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Bibo Mao <maobibo@loongson.cn>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Colin Ian King <colin.i.king@gmail.com>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 20, 2026, David Matlack wrote:
> -static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
> +static u64 pread_uint64(int fd, const char *filename, u64 index)

I think it's also worth converting the function to pread_u64().

>  {
> -	uint64_t value;
> +	u64 value;
>  	off_t offset = index * sizeof(value);
>  
>  	TEST_ASSERT(pread(fd, &value, sizeof(value), offset) == sizeof(value),
