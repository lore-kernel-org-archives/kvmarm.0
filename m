Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036730AAAF
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765567325; cv=none; b=sg5xauPS4g7kKsbu/tgvRX1TLHtFB3JfZZdKnNZhBOnctezW59TJtiYWdnkE8FUtUw6xsVF7PWdF4wqXsgBq6P6V25N15OgSu85bXcD4ThXA4V7IJ6uNsbrqQ7cRJ7zZLfdR/jRi+l88FQmHtDczOFr+IaJio5nVYv8X2hSUAdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765567325; c=relaxed/simple;
	bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MEuA2w8QV1b/15kb/Z7yTJJr348BLLENSVosbHF7lX9k7LyG2xizyNR8j2iAHggUraZvXRFlXd1miRaijhLgRS7r+GZ5q5mmEcXkavuEzjHJ9cuHlA8wk/zubb+LafiNAH/dyEfcxkKILeXz07sF4Il+joL6JXV4R/5tJz4gz2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/1WCt2z; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/1WCt2z"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-3ed1786c92cso1229536fac.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 11:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765567323; x=1766172123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
        b=I/1WCt2zgxfXDeJB5BJ8NrmCoCwnlZkFLgq7KG4ho1P3O7/VvaehLuWMjpmTg5LNuV
         NqB491g7yK7ZRu+nhF3q7lVjwCWj95+VMdLVt6lnEazqi0eY3IxVnU5ln49N4AqejeeR
         7uy/b4X5d4OiURa4+m8R3xFXa7IMh2nUYIESiL8G+aUxHjmWbRU+Kxc+QfUwtvYo/7yZ
         2P3oPha0YZ6Ye5qrFnq9di7btaJGL6GPpoKRSG+T6B6gIarnTQAtU+ERUFyPN+y47WqS
         KS1vkumyodGm/NF4BKCvzj6YnVEFyyLCrMjlaSE0SzEHra5WfbJVRONPN+vKum4otBe3
         tVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765567323; x=1766172123;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
        b=kaw6wgcJX8ruScu5R+BF5Ufy7lItycDUwddvu7Uw85ANAHYV5DWxokzwc9pWL9LhsI
         /618Tv+a7QcUSZdLNBeazWej7bGo/JpzpFEDv1r5/dW8XuixKsTwLf+XcuFm6zS5BEnF
         GvLZJPoi6x7jEZ+NUxXHQlFEZ47Z62GpSK3yPTTJC0IelJIIkga9R88cu25wMXoLZzWd
         JBOeBzgeCUTbzRjn22xNpMx++Hi5FyWiNPxr69bSwv734KIhSgBF5t+USpPlRrEZq4yj
         yAwD/4aNlYKHEvcDjbV7VOmsqZYAp2ACRnq5DYi8IUWWiZzWoRIYy9KB00guTp9bDDp7
         uI5w==
X-Forwarded-Encrypted: i=1; AJvYcCXacUcBPHn9xpIA5AJiJenpTtnEz5YjogA7ZUuD9itUZ5oeU91Yx796QYK3Qh7BvIwJeYrktt8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdl6syQFSH4P3TI3UPcKg7HwuruJKAO1dSNGyPmBvOHDebjwPI
	xmamMg5Rc3N6tGcd1RNKHx0s4EpS4pXQuUDh4bq5shBu4174Fy7RoFumNuaaB/HxzPiPxyP26hZ
	ro8FeztCGKAwwRTLPlXDHo8n+ZA==
X-Google-Smtp-Source: AGHT+IHUbVv4Jy2gEZEkXkuyNos7MiNpoCrDqCxYPzir5lZi9qw+P8UnFJM3AYzANnUq+aZp9M70/ycADG43mzjJoA==
X-Received: from ilbeb21.prod.google.com ([2002:a05:6e02:4615:b0:438:317f:a956])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:290e:b0:659:9a49:90d4 with SMTP id 006d021491bc7-65b4523a33dmr1491761eaf.83.1765567323163;
 Fri, 12 Dec 2025 11:22:03 -0800 (PST)
Date: Fri, 12 Dec 2025 19:22:02 +0000
In-Reply-To: <d3e946ec-787a-424a-9a7a-f04aeb490ba6@arm.com> (message from
 Suzuki K Poulose on Wed, 10 Dec 2025 10:54:10 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt7bur4iat.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 01/24] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 09/12/2025 20:50, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks Suzuki!
