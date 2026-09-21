Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5244ACC74
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999651; cv=none; b=m2k9dHwUiMcOqzCl5dEdmJ4Fo3XAjkW3IvaTKg/XrC38BHd7BeOSa1Et8H+8Qt8FQDsXBZ0lxxhhAnN3pg2D3WLvcPu5Ob8lmwlfGSdxpaw0xv1Qu/kAw/rmL+7V8lgptI8FcHWCzvPajcVuCWIIblig4YkMtguKBXT+CHC/9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999651; c=relaxed/simple;
	bh=l74fNDk6VO8vPprQl+zeIl7U2mcronWS4nPqTAUnEVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kHSXhG7QYHbK1FySd3C7Nk7pI1BlOaaWP9t3eo/vs5u74FJqZyYYEX8dfAGF1RvF+wWjRW9L8yWEketBUXMWAsCXDv2RgDuL2+B6KJPpJIRqggdDq6PbVI170jy6mLIyyayFQD3C51snXMhJuw1oIXJGfe5ljx3DrSrKF6N0OSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+RO+ZqV; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+RO+ZqV"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-86b4048367cso4051953b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789999649; x=1790604449; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GyNDJX3fIEdqZwMfzP/6YwVAKyII5CaZgMpV7trI7WI=;
        b=I+RO+ZqVA9JE+a+SvaXvzZ5+EHATiidOB84RTKoD+MEgXl0q20q08DNGXLXH3nWBA/
         8gwDgdfqBh4Xv8jyykJ13ahbqVG27hq5+50CHaAh8MANijDI6e8T8yN5n8ZwUP06QYkX
         vqy4cjDyszGwKQsq0JaobohT7S1D1bVLY4iVUzE87voAK7EalXpoevUFuR5T1x2rjT7Q
         wQA0UJfb2B/ZWFQYACunCIBhODz4SMNtEeDtBFQ9WCMykXz4YDDnGWz3JzUKeocpabWZ
         O6LB2nQ1DSTziKGesuAsyxK29oFj6NJ+xOqtYEtgOZxXg9K2QALgVPAhfk/YPl5vhdk5
         K8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999649; x=1790604449;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GyNDJX3fIEdqZwMfzP/6YwVAKyII5CaZgMpV7trI7WI=;
        b=oGVFHsKliUMDKJsD76/urYXIl8kFZyagKb+s/OilGLey8rvLARN+AONpy+0UpryPdb
         K93YsCITVO5rDJ2g9QYpdzKjJEWHg36SWoWey7MpmxPAmlhL/kINGiYFIDhyn2UMe63v
         NsSgZnnV7VL+iXQ2FhMMLSIyG+hI6dfQhnVqvXZSfLJCsB827vN+qv8Vl347WdmVau71
         FB9Nzjy2/ISVVSq3yxlTpe33o6o3A5XSaCl65wTh0NZvr2Yn50vJkvIx9rjXe9E2CrKg
         IQKuyyWrBq9Qr30DfIVZAxr64Jxa9W3B1pJkz9vKlA5kqwKJ3GbvnGJZmVPFDd5abyrZ
         1w6g==
X-Forwarded-Encrypted: i=1; AKwUvBxb0qNhWA4E0XkoFTDfnEHrSmMz6q2QRlADZL9PRhH+2Iib9zl/+Hg12vE3s2BlBKse/sPc9eI=@lists.linux.dev
X-Gm-Message-State: AFuF++nXHL034MsAnJCNmKS0AsbT5tQohFS+190mS4V/BBLUAKDFl2uw
	iXIY17+IwARHzDXfQSQArGGQKOAwQItSOaOgFKigtWxcPgtkViyWgwuZB3ZU7GG4mdQwFjNlCYp
	IUoTdHw==
X-Received: from pfw9.prod.google.com ([2002:a05:6a00:a269:b0:87b:6530:9518])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1c8b:b0:878:34d7:6977
 with SMTP id d2e1a72fcca58-87834d76c96mr7399999b3a.37.1789999648656; Mon, 21
 Sep 2026 07:07:28 -0700 (PDT)
Date: Mon, 21 Sep 2026 07:05:34 -0700
In-Reply-To: <20260803170825.925561-4-hisamshar@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803170825.925561-4-hisamshar@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <178999928264.755166.909574492736686331.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Replace ulong with unsigned long
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Hisam Mehboob <hisamshar@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	shuah@kernel.org, aqibaf@amazon.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Mon, 03 Aug 2026 22:08:28 +0500, Hisam Mehboob wrote:
> KVM selftests use the non-standard ulong alias in several files. glibc
> exposes the alias transitively through its headers, whereas musl does not,
> causing musl builds to fail with ulong undeclared.
> 
> Use unsigned long directly instead of depending on a libc-specific typedef.
> This also avoids adding a duplicate typedef to a shared tools header.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Replace ulong with unsigned long
      https://github.com/kvm-x86/linux/commit/5be2d20f9818

--
https://github.com/kvm-x86/linux/tree/next
