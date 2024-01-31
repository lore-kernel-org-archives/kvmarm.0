Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F451804D
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662814; cv=none; b=J3q3RQdZsYyQMMpXuaPMAtvnaVvuNsURr+9NQ4RRbSpCUtsMDPHoD+bZYCo6tHV/2vSbwNTYu/nctKbR34UhYhPGIIhhE61xY6pEKvJnnd4rBlCZzMkngomNPIfng7rZtxsCVJ9DwjxF5ZG02ZtGAR9Yr4kulyajDctMoe+fUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662814; c=relaxed/simple;
	bh=wgGzT6TUDG48PPLloOo3goD71TIEqTK3nSrqgx3qrtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AGLJEUVQfzJGlVeqz3Uyc2C4FgwmXqBgAG2PtpmVHekZb8zhbQ2qy8aWAKHgDBq6Y7ZfJjpEHfuJsAljUd8QXdYBUYcw/ErP0dy3Xhx26CwOxReCwcSpN6g6+nZmBa6KCZZGg8MOaJoiBtORDK4Cn649jWkieyjABTrpBYSJ/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GuD+9UcZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GuD+9UcZ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ff7eabfd94so75222207b3.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 17:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662812; x=1707267612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=imus7iG1fygzlM/+HQtDbXSzUkJeHNIgQ1UAJ0qGMVo=;
        b=GuD+9UcZYZYzgjp8TPXq9Gluux1gXi+wq56tmvvLFKS9E7RIcYgyj9c+cOjk/l3JUC
         hIB3INbJQj9PlmlJEicVXWXBNX/y4lmF62nUjSh07nHKiI8A5uvTPMfAoqs9eDzm1KAt
         +fPhQu2JhvaopS/4DTBfm19ev44cdC65gCxSgDTYeFgl6eoCJTBGKQ7zanNnwhygt7mo
         1sPyc+Eh0hE75EW09B1FRU+n2FA9QbOQVpvnxrfBfNXkObCkC3ENkzF+vXkRv8DcLbz2
         fRmT9mfB1iwlDj1ZmbRglciYYpWru6QDQvr4lCPVLrT8CXmEHPUDfOSs2G9Q74wyD5l0
         HjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662812; x=1707267612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imus7iG1fygzlM/+HQtDbXSzUkJeHNIgQ1UAJ0qGMVo=;
        b=HmTUqc/nsOnkylVn9sYGeEGDErzBDVCLdSlajej2SAh9uzTTrbRXerQXtfMLPV/LB7
         cd3iga0zTJFfOchpxU9bl1c003/FMZz7ILkoUExfQXv5cbL0X2cfJavQd3drF16h8IID
         g6SSwEAzuhvSPbFRMzMcUICu0B+d6Acv0aiZTZf2a+m31Fxtg9p2WhD9AjbBq7Ii+1BF
         KYVpdE1Do/BdeOcix7vazr1pNseGgJky/lLgOFNjUxBqVAYySx9BhkvjQjKC4Fjw4/rS
         uZTuLBbFgkQNq3KBHJLkoDndsTtvtVck5BxA0tlg5nW8e7cyty8IFWD7JLJRxxPpNHvZ
         EuXw==
X-Gm-Message-State: AOJu0YxexfJmvoJFw0v9uR5sTqrAEJpRwC08mgp0aykXsIyXh+RyBwqN
	RJ0A74l7czlVl8wahC0GZ5qoc8YUkGypAxBb02Twf2wQDwBennnFngLxU2sCMW4B4f8FHg71OVz
	jsQ==
X-Google-Smtp-Source: AGHT+IGoolaig8BLWgySJofQnaPMqobQkEKwg5l04qA235dPVfbdb8mdTfDb/M1PXPWp3ev5IMjPTztNJB4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:15c1:b0:dc2:4d91:fb4b with SMTP id
 l1-20020a05690215c100b00dc24d91fb4bmr61290ybu.9.1706662812244; Tue, 30 Jan
 2024 17:00:12 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:21 -0800
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170629088388.3096286.8233473691080181709.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Remove redundant newlines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, Andrew Jones <ajones@ventanamicro.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Dec 2023 18:02:42 +0100, Andrew Jones wrote:
> This series has a lot of churn for dubious value, but I'm posting it
> anyway since I've already done the work. Each patch in the series is
> simply removing trailing newlines from format strings in TEST_* function
> callsites, since TEST_* functions append their own. The first patch
> addresses common lib and test code, the rest of the changes are split
> by arch in the remaining patches.
> 
> [...]

Applied to kvm-x86 selftests, with the fix for the "tsc\n" bug.  Thanks!

[1/5] KVM: selftests: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/250e138d8768
[2/5] KVM: selftests: aarch64: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/95be17e4008b
[3/5] KVM: selftests: riscv: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/93e43e50b80b
[4/5] KVM: selftests: s390x: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/a38125f188c1
[5/5] KVM: selftests: x86_64: Remove redundant newlines
      https://github.com/kvm-x86/linux/commit/65612e993493

--
https://github.com/kvm-x86/linux/tree/next
