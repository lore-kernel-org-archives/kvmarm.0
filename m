Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157751DF269
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843555; cv=none; b=H/Q1IogdZaVKRPoZjjEmybA6pdkOW/11Mh060Ed9s0fjd3c01dkOXXI44nK6f0Rlopz7TWg6kstuMHBRdfXsFG7lNWsvVO5tg/eDLAglqiJy5a5USWcyb3Qw49HIISqen+HlkRELhYGzv3gVggRWpYo2ghwC1pmi6GQzUjUUneE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843555; c=relaxed/simple;
	bh=Cj0A3QIDVPBMiKmwKKjgWt2tMKBjdb3nDiyOrIhKRaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=TAMOuP2rlGc94IBFuj5l38EZiyac593RlT+iRw5saVq4bYDhv9dhO2nr20qcuERyDetcPRNR4wzg9AcN4H3plbeXwVJCx4VWQULHwC57JWgI1srOLh/EPq5US1O8mMS9X9woyGWJBPuBVxorSOkkl0rNNaltoG8FhwXGcFBDwF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hovY4EVe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hovY4EVe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c4skaTSZXHQuIRmGbiy2gxynizyJICG1cT+Q8yDgioM=;
	b=hovY4EVeTfQicubJKAktVHlICc1a+eZQr3MHGdXCtcWcYou4IoD+bbdL/+lZQFZPhY461r
	buHK/B7hHgXru/M9xO4cA96SH/t4/moHrr2pYtarm9s5Nbe+vYnZkP8VNxsFcAJgQsAhW+
	hiuNncVIZZVKCmCFmLfpOgEzFAFAXNk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-lsN_tc4uOjyNMzywxEYhaw-1; Thu, 30 Oct 2025 12:59:10 -0400
X-MC-Unique: lsN_tc4uOjyNMzywxEYhaw-1
X-Mimecast-MFC-AGG-ID: lsN_tc4uOjyNMzywxEYhaw_1761843550
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477171bbf51so9370025e9.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843549; x=1762448349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c4skaTSZXHQuIRmGbiy2gxynizyJICG1cT+Q8yDgioM=;
        b=Cjpp/Nw5iBTw5j7ZFnE01yS0moRwYbT4Fr+XLbehOostu8z8/Es0PPQXnowvR1Yym6
         tgP21vCSg3M6ReNJht0XjAw5zFoQRDjWnQmUdJTLUZhlgzjxJQhKXevqtVHYVFABNq3f
         LkpUn1ppszbD1ZlAG++0igXY4IyQZ+GSs6Nou5DdR9NIwEVlfd6rFiv33gMXTojmIMyi
         gPaiSSZ1OFQuD3GkPgfL5Zr6ohWuVGuVDqND75VMm2F6QS62G+Q4FLR6lwI5ZSFkn00i
         B9Qd79bpfTR7NbCz0KSmYQnNsDcUT147HnqG6Iq6FEs8XrKg4dO4+XtOHA7+MiulmTg3
         DRbw==
X-Forwarded-Encrypted: i=1; AJvYcCVfZ4vhA3Qt5eZ6sm/z9eEEqQeY4ehB4lf7oezC4vCQsEGCB8bR3aZCQoPfp4Vlbukrmu7mQhg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9CUjoqvQRvKntecqKzT7J2WYTmhN8Iro8p8HEijR67ie6TToX
	iCwBAqvURqkedXqqDb3mKlLvaPUMTy8FrDuZd7xA8RodntddUJarJS3CNBhDm1++ZCM1/4qaAqG
	IJ7T5woW2VKnf0HpgacLVd+cQDTIZIzOqaHVzT4d3HHVgpK8glTnYKiMqow==
X-Gm-Gg: ASbGncsamrX858dJ+ORtdYE+zI07q8wkdmkyWCV7cotunpwvxldEO7pVa+y8VAWmJft
	27hW4R0vPLNiveL3XyrdIVN9Jg0jJSEMuAmvNS/a8+AYc/Ow9H6aNueZ0jE3+mlJ3ppa05gKfxJ
	e/mGfExCay0tboLIGHIjFHzctGE5w0pYsd1AxqC90T2iw378AyyddFKbTsKkMcby/yWdlj3yK7M
	NXUYZk8CEUnqkfan16ox6SY4GS7x8DE9HCESGtN4kuFMbp+9vkjtoayXM5ch/8WjarOy1IENSzm
	ppGNwdvXgceoeZ52vNtuMNnIpsg1dxVD4xoL0nacpH4lrCTmL1vlz2h8YrSFawcP8vl/QDIuD//
	OLU1LSQ3q56KCdef59OpqtCuSlUxXOsy7egd/KaLF6lAsJuoVqK3O0ZieHW5XUu4=
X-Received: by 2002:a05:600c:841a:b0:471:672:3486 with SMTP id 5b1f17b1804b1-477307d7648mr5007455e9.15.1761843549526;
        Thu, 30 Oct 2025 09:59:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt7B6ojHr/3JYckmLT4sLA4gFFjBs0ue4eJPWN4fnRoRr5RGdu8WPcg8CocqfFNx1nXc9tQQ==
X-Received: by 2002:a05:600c:841a:b0:471:672:3486 with SMTP id 5b1f17b1804b1-477307d7648mr5007155e9.15.1761843549096;
        Thu, 30 Oct 2025 09:59:09 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 0/2] arm: add kvm-psci-version vcpu property
Date: Thu, 30 Oct 2025 17:59:03 +0100
Message-ID: <20251030165905.73295-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hxJvPUvm7XPeQ9F0JtBnEH1SUgoyvaLVHHUhiLhCPP4_1761843550
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

Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 ++++
 target/arm/kvm-consts.h          |  2 ++
 target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

-- 
2.42.0

