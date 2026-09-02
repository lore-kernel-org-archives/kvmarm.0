Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C3323D2A1
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788309628; cv=none; b=hhmILVJP+gC0wCK2zIOcVklZKGOpHquwlXYqidX3Q1a1LkHZImcotKRZsqOdfs7ZpH9zNMIq1/vWGh44r4cYXPNAdvIyBJr5EckxP8LnoTJ+btJKy/XMgPNzDE486lpWHtByFBGGyZ3ImD0r/+qxVP0erJ4uH6sqwOhpFeSA6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788309628; c=relaxed/simple;
	bh=vaDS6XNQUMUuPDi84wd9HFSG8Scz5CNLwlPkibF3DEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JPErjtqeQmjWaJwNpSpGYeUyGwe7JdWi7+Djob0KgQ5+GKUSeiOl/yReUyyXCOKllrk6K1aS1n9JFbwtXnNSdS1ru5Lboa2UbLpfMsTVTWQYJ4jmGqbKnp8VK8MWgwcs7DYWsvBUQVhuPL3+0+g1VoCYUwBT73fCWnoAmUezutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qX1VFrMi; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qX1VFrMi"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e13b57b2cso565307b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788309626; x=1788914426; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Yk5W8YMQMFUnjqW7SP37P8eIRPlwXT5+5U93q8LYb8=;
        b=qX1VFrMiXkwRU5u8pswCuToPB3r15/jsUDkpv5sHPWJJs8w1UwSvf8KwGjz7VgObZG
         hGQXNQqUB9+qOIYJsMaBNyttY11z3wQnFK2qs01Uv3hYGRUQflbMjWMvEuw0qNoUQdtY
         N8SC0RXRtmcCQsr0zQWNd6s3zw8HgDOifGiQAjQwKwCQ2ra3YTCzEJh0m0wXyxt9JWyP
         KQo6X2/lJiYI1rDOnILZJnHtFhOcXvsXV4YrUOmdgpT+/pX0+pVKimY5iP2LMU5xngfP
         S+IPh4W4XebFwivsu7u2cTNxyKK9aXHR+ds/lW1L9NRLWBTlL/v00KIcXEX/C5DVful+
         LAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788309626; x=1788914426;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Yk5W8YMQMFUnjqW7SP37P8eIRPlwXT5+5U93q8LYb8=;
        b=S0YVZkeIPisOAptIUP4FdZtfTCQW1enoffVFFb4gxVq9tkq0eNaTgbHwaUZC5d2Hqy
         f/yLGTqY9bGhy1zrS/PyYy3rEag6CIUsRjyjsSfLuFDtUM+2HSACYUUa6AyajuEYtsF/
         NKHVFS0gZoKYdciMzXEZYLopZXn4xNhYfI+MgWl7mlXEUTNUQqxuTqsu+LrvMTjkwtDz
         pvkpUYsOoAJ0GJvmDwSp+R4R7fjG6VN2q4U0mwbDd/J3V9qkfR3xU+hl4qRTw+TRT8KB
         fMhrLK5lBpt1T5530IMwxfQ39FrPVwTy4kDrOnSIvgprB+tfyOwEDF9sT7jiIU4ODhg3
         4f7A==
X-Forwarded-Encrypted: i=1; AKwUvByqbQGDLewO45zDdbp+rqZEVJagF3YiiWqyPH6xKpcYsDjtMg6HoPHBUz/hmhwRB7vrpycJ7O4=@lists.linux.dev
X-Gm-Message-State: AFuF++mxkGrkPy7dA4hsKVmh62g6qRDTWO0Svg9lUzjJDn2AthbHwBlG
	0xMsc3fvsLHOG1dPTxFD4guSfqoFU0dZi0Fnu8dsgmOEKRHSBWmtCBMCCO2YuP/+yoLeOdIpx4E
	o6DzYNg==
X-Received: from pfbi25-n2.prod.google.com ([2002:a05:6a00:a519:20b0:84f:4ff1:f767])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ab08:b0:848:5cf5:5040
 with SMTP id d2e1a72fcca58-85ed23e044bmr2745937b3a.10.1788309626365; Tue, 01
 Sep 2026 17:40:26 -0700 (PDT)
Date: Tue, 1 Sep 2026 17:40:25 -0700
In-Reply-To: <20260831144802.834315-3-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-3-seiden@linux.ibm.com>
Message-ID: <apdweRfqt4dTxcU9@google.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 31, 2026, Steffen Eiden wrote:
> Allow KVM implementations to choose alternative device names. This is
> especially useful for architectures providing multiple KVM
> implementations simultaneously. Architectures providing multiple KVM
> implementations must compile the KVM common code once per
> implementation and mange symbols.

What about tracepoints?  Or do those show up as "kvm" and "kvm-arm64"?
