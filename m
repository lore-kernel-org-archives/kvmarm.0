Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589796;
	b=AEGdsALzcXvmNdkJ8PTEiGQYH6roOqgPYO8nAz0C8NLRg7A5Q+Bc1ABfnwV/ow0W+MPC
	 fQHbEiR5jh1AbHhDhcn4cJCu+E5QVybHzilkPXN28pz9HyGWFCzT5qn4Dp7EvWVlXbZ42
	 d1bE/VWNqZ6QgVqyS9xchIZJbotE7G69OlHRl6yIr6LNg9G+h5ekfY59lS3UQ5X2MEgGP
	 4XcfAgDg6lTsLQjEpZBY1eh052MFJxH3rd12pV+3H3fjVYKcypkMZxF4Q3MsvQqa7Tk8M
	 AKNvofrtfbNfgOR5VdrnSKsmUKhfk/juVn5cgZ/6Q4aEJweSHQUB6BIK9oo7p3UzxRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=WQnd85yPB60bhdolGWcMJlVAtTrb9nbyVFLWQL59DRE=;
	b=KMuRKSV2m2YQCaVy4t59vocrGX3IR+b0Z2Yju09eQpTBJn9HSlfcIAXVHHSzN1gMPJkd
	 usL7QpCXVi9AZUMXbdVRzYI1jmRYlqhrS/xx9TWMmhe4PjZfs+NS5SAjGWWZE8sVLVg1A
	 SFvLMMNgNaPVW9Y0jAg8Z2zmuWarJZCv5VQvmhCYqakW0OdWsDeXuub3ST8QcWPdpvx6r
	 Y4kanK/02Wn2uCZrGnWdFDOKQaqmbBMiVga2U+7arGK1vQ7MOHum8PqUlKrtISMWwZSXO
	 o+PSskaTT8xa4KtUPm3yiePfFqQHAsIwf9u9/a7A+oXaDoHyDowWgXy3APyh0ShoGJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b="Hgem9/rw";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403C606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E403C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Hgem9/rw
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso39514625e9.2
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589794; x=1796194594; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WQnd85yPB60bhdolGWcMJlVAtTrb9nbyVFLWQL59DRE=;
        b=Hgem9/rwJpx8GRO6yILitxzq85gE1GEYkJ7YroXbLsDCKk1/JFM00Yj/p2NYFkPdmP
         qvtDIj6XnmgnUiwoy2nukOgpjqVF0lF4PUHnplzgdmww9Z2ONHzJGvlqNbCu2nj85bH1
         qjlu6EP8fr99qtjh10KbwXIO+fAfxeWU9wfIcEsZif7+/+OWBkZSd4nehkL7TIUGeiib
         XgtGC7/wSskBU4XxIE5/Z8Oap0BTVhJ4Jvsv4G30ETwFZFFyATzpwydEypI5N5cgFPa/
         KF7z7umwB30rLJES+XumghxKPPe1Sm1onl0ntSZhWWcg74GBfjy+KRtkPHIyFiXnZNo8
         wUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589794; x=1796194594;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WQnd85yPB60bhdolGWcMJlVAtTrb9nbyVFLWQL59DRE=;
        b=VwiBlP9t8SOi1S7Nv03HvfpH1hefNsYxfgDnACBdqzKuJv1G6rAgBjZjtsQHLXjJZh
         cHQQzXnjFvc2LcBDkC5m3vfmX4mGn28wQJcskV5tA1zjXb4x3u9CUOirjA/9EE8bPk3A
         Af9KK3S3QbepZRe1ZFhGG5aWpCPAvMU0qTIMTUwJZHpc7z9qdxyzzu+Ac/8XgSQmP1Yf
         hLDYeAgHea++4Cm4YmM8IYV1jSHdv4ipNfnxVJKsbxIoosQp01X7v2WZPS1pf4P9dPEo
         GMu5IhacXln4yDXLfUpIBoarRgkBhLwy16ObtclRr5UmbXzdAWrC7+T5Kv2iq9TyHRhK
         AC3w==
X-Forwarded-Encrypted: i=1; AL+hErGohfOKfMCGo0ZAxIEmtAql+OeJEXm4r2Jp48sJJLpRK0cXjE9GcCVTB/09zZFiN6j0xqNSqW0=@lists.linux.dev
X-Gm-Message-State: APuU4Z/WRPT4OC1Og6H5Yw0F4f5kWU5/1LvvX+iOV2Wmd/CEcXpo+rm6
	n+KTNADAP9Xiat+9ZxthYnUDu1zYKBoNmewwiHxGdfIZcxncgg6m7MpewLhBrDMFoO4=
X-Gm-Gg: AZFdTZcchzD7gPnAwH9G/gYlJrm3yBj/T8liBH2YkkmQQXa/ROfW2cdyd97mqsAywjz
	xPycTI70UKZi/6oMEu2bp5rVTkgnOm+M18Ix8yHCE/7ME6J5iID55ruBtGwLsJIUkjcxWSDwid7
	PIwVCuVpt+QgHwttMiim1y5nBxja0CTdDv6KwbjdQ9FMLZCZlilm1kia/3ntKG5NqqQ9ZB0cs7p
	mYFANoFHbV0ch56vdDu50L6NWcuPP/GZpny4fcDqiz4eu6VA41sebYCoXH4q2kXYKcFmUOIzHKb
	RmGNwjchKyHGisX2MU2F3CWJMefvX1vh6slotAZzz0K3+JbA+yxAFeTc7jkHzFHeCdX+2qlDdj2
	32m0Y44Uz30HwhDW0N9AqFeYWubx/yFDWl2ZvQsBPQdPUOLab7nhQy4SBB5tKBICkpN3qbewfL2
	5glVPI61fmOMx8ICF0i5/9fowdlEijEwH97Bj7Oqq38X/bGxEeWMP4mOmvEd/ayL1HIZRaxqqtu
	5dXOLDnjELkxHl69cJt2kts1gETpiN5KKo6r/Hyelx3Z3spS6Y2w2TVlTXkGD70wsL7N/ubsNNL
	kPGHY4czD6TxosHrnGe7
X-Received: by 2002:a05:600c:530e:b0:4ba:eb:eb9b with SMTP id 5b1f17b1804b1-4bb8880aba2mr330852995e9.8.1795589793909;
        Tue, 24 Nov 2026 22:56:33 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm777474785e9.14.2026.11.24.22.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:33 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Subject: [PATCH v2 0/8] KVM: arm64: Fix kvm_reset_vcpu() and SError
 handling for nested virt
Date: Wed, 25 Nov 2026 09:56:15 +0300
Message-Id: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WOQQ6CMBBFr0K6toYZxKAr72GIaaej1BiKLRAM4
 e62GFcs/8z7L38Wgb3lIM7ZLDyPNljXxoC7TFCj2gdLa2IWmOMRAHNp3KBffOOJuOsjLFVxMEQ
 lAkAlYq3zfLfTqrzWvxwG/WTqkycRWgWW2quWmnTaGNM/cY0NvfOfddsIyfefUWxnjCBBkqlQl
 yeFBZpLx57fex5EvSzLFySRl6jpAAAA
X-Change-ID: 20261120-double_exception-a34dcc521118
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Christoffer Dall <c.dall@virtualopensystems.com>, 
 Rusty Russell <rusty@rustcorp.com.au>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Sebastian Ott <sebott@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0

Our formal proof work at Pereq found a way to trigger a WARN() by
injecting two SErrors.  Then Sashiko found several related bugs
and testing uncovered a few more.   The original patch is the same,
it's just that I have added others as well.

I have included a selftest for kvm_reset_vcpu().  I have a selftest
for SError as well but I have a question about that so I'm going to
send it seperately later.

Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
Changes in v2:
- All the patches before [PATCH 7/8] are new to fix other related bugs
- Link to v1: https://patch.msgid.link/20261123-double_exception-v1-1-cd82b59a232d@pereq.eu

To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Christoffer Dall <c.dall@virtualopensystems.com>
To: Rusty Russell <rusty@rustcorp.com.au>
To: Marcelo Tosatti <mtosatti@redhat.com>
To: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
To: James Morse <james.morse@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>
Cc: Clément Blaudeau <clement@cryspen.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

---
Dan Carpenter (8):
      KVM: arm64: Drop an incomplete MMIO access when resetting a vcpu
      KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1 when resetting a vcpu
      KVM: arm64: Discard a pending SError when resetting a vcpu
      KVM: arm64: nv: Discard nested SError in kvm_reset_vcpu()
      KVM: arm64: nv: Replace a pending SError when injecting a new one
      KVM: arm64: nv: Don't deliver a pending SError to the wrong guest
      KVM: arm64: nv: Re-inject a stored SError after the exit is handled
      KVM: arm64: selftests: Test that a vcpu reset clears the vcpu's state

 arch/arm64/include/asm/kvm_emulate.h           |   1 +
 arch/arm64/kvm/arm.c                           |   1 +
 arch/arm64/kvm/emulate-nested.c                |  14 ++
 arch/arm64/kvm/inject_fault.c                  |  10 ++
 arch/arm64/kvm/nested.c                        |  16 +-
 arch/arm64/kvm/reset.c                         |   8 +
 tools/testing/selftests/kvm/Makefile.kvm       |   1 +
 tools/testing/selftests/kvm/arm64/vcpu_reset.c | 210 +++++++++++++++++++++++++
 8 files changed, 251 insertions(+), 10 deletions(-)
---
base-commit: adcad7f4e6332cff3d6d7165f41584899f598534
change-id: 20261120-double_exception-a34dcc521118

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

