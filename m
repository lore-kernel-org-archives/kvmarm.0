Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C23431BCA7
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971252; cv=none; b=qQSkef1e3Fb7weqR/0QZbE9k93oxXPBscKrUd/Isjr69fQbu8iPu1D7ceAp7ut5lM9kEHXO2pjl+1VzxSEKZR5obcxOV8fm1egat37PdIXSMrhFm0lUUKffENjnBbrhlst9vZhG/jhgxUbjA1kycSi5BE3HWlJSefhm4MKLfvYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971252; c=relaxed/simple;
	bh=2fL91WULS/rZQmHZyuQUO6TygM4iRQwAhrVr9f1eNTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=NbnBV4o8/ZccU41i2LnHATRRqD5sdv89sJqTFcMVOu1i0vsheulegIuN/7Yxc9rQGerlGB3TMAdoHCHFNZpEXA5iG21P1U5fIQTgdERMYJZSvsYOpD2BU35lRRtZ0XxWodYE9oRKxFqaxqktHnJiQWlFuLJXFIAvJJsDoJghZ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUs1GYjF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUs1GYjF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6wkDGLNl95u4gTMNts1lwy5hnz5zbSzJt2V8JBhOwjc=;
	b=gUs1GYjFE3kxMdQFKbmKBmfHB9GRRtVFjHScXkS8peuawmDXcdxXgOM+s4Ddazpr+kUOKY
	LcDiDDrAh2V0Emqk3AAlC86PPS45OCw9Q/fqjwcuMA+4GjWwhOGYcmH7dJ1KsXiyCz7RAJ
	rN5NQJjv29QbaSJwxPIGANq0gk0SckA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-OYp9NA46Pw2wnpCVRCouQQ-1; Wed, 12 Nov 2025 13:14:07 -0500
X-MC-Unique: OYp9NA46Pw2wnpCVRCouQQ-1
X-Mimecast-MFC-AGG-ID: OYp9NA46Pw2wnpCVRCouQQ_1762971246
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso7081545e9.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:14:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971246; x=1763576046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wkDGLNl95u4gTMNts1lwy5hnz5zbSzJt2V8JBhOwjc=;
        b=iw/gJy4UJ4iRitAGGUk7A3knVzBOez117nadmP4bml+r4JLe/fejk3SbUjbrZKlPlA
         7/6TPLb/Bv/vZX3foQD6RS/F62X3fVSE3tQ7GikUEMOzyL9xQsnAIDWvrXYZTvaTU3vm
         DSH72Pel+B6VIZmSyksjTjb2kP3ncxPoCxa++vdg5y6+5+uIQpQYHvOZ/qCNhQpU+kzd
         mWgHRUeqS2yUbTXwZoo+jGAcX9krEE6tgybOHR+0Y8ujnKnwNg82+FJyldhobkHP6/ov
         FJVaH1jsd6umt8jxCDPjG2eeu38CWJZ3gpu/VkAsgTyWE4v0sxXUJdHx90aYTTC/0/n7
         SvkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+ARIr1nyNlprdiX6ruEL8S9DsOMfzzH7efwuuOqDMOX3DHqanwEAWzduz7vrro8oG+Rtljhk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHXVM9r5/xwo509+ORzn9rOHBHqUTugB7wZO/5nyGVI9vlTmU+
	JnV8D+UNEMh++M4UuswE9B+F9KhPIoJbpLe5c0h69pcqjRA6Z6uRM19MkdFDPYpk33457rk6Uf/
	dksLrlTPmeZ7iTJXKf1YG/2KFtMyG7hsrgNVJToo5gITI/N7kWeGekN/P1w==
X-Gm-Gg: ASbGncuvfiLX9vpAFiSjFH2u1YQC4bSqe6JmIBl7SqFNEwa1ED548BVVGS1pC1NjLAr
	vSEfVrY1OnTfMcPybl4NaVxOgW2gLpE0kI/wds2eEOHCCHb/I46Y+hjw+lbx8XdX9Gm+RZmo1JL
	7P7lii7a15cJigagnTYaQTb68GaTkr39kMaklJyZa1BSXiyaCT9gXh5hE+3zcX+59A+Y2fEdZJJ
	lXB8DwuJtB+ilB3zV4QmZnM6xx1CN6brvNuhzR6ai2+3uTLtQJz46vj92BrFZJt3YpkwNk+cVp0
	H1BIh7doJqsyT6dtHgp1vwMGGsUsOKsNENOxS9vWxxZHyAv85hb9fEQVlzElWl9xJ5qpjMdWhGH
	hlr4huQ5TrOdLGRp3aLWRs3J1WeOV/Dt14i0HqRNpvq/3s5/auOLVX7v9OvX4wg==
X-Received: by 2002:a05:600c:4f54:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47787071103mr41219925e9.1.1762971246464;
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9+tZW+TZfDNytcYdvgsMKLxtasoyhEGtTeovHC2gFRRAmyVWZ9b21XTXgVv0PcfEXirpotw==
X-Received: by 2002:a05:600c:4f54:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47787071103mr41219625e9.1.1762971246059;
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:05 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 0/2]  arm: add kvm-psci-version vcpu property
Date: Wed, 12 Nov 2025 19:13:55 +0100
Message-ID: <20251112181357.38999-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gKwTRWvhlpJcvwchPjlFu6l3ZtostVpzB06bjykMv4M_1762971246
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V2 [2]:
* fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
* removed the assertion in kvm_get_psci_version() so that this also works
  with a future kernel/psci version
* added R-B
Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
[2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/


Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 1 deletion(-)

-- 
2.42.0

