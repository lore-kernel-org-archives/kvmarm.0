Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8FB1F09BF
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220684; cv=none; b=d5hDOoDr1dKZNB8m8GGpn/Z1509izxFcqs4P+CrxsUOdG0lOeYvoU0O2bWhqDH2Cfx8EqH0JcqzYF48UNHsfq4e0l4nUNHgUYaNR8XT6+TqV5sTUB0Io39Li0iNpci+2QCfZstwi0D1z0yWOZldsviG3+PBu6EIZvV2nJuI4bQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220684; c=relaxed/simple;
	bh=Xd+l4yVTMF6sIq+heJRlqv5EUOVaKyXfY1hn736d6Rs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQOjuVKqGNda29u5UrGnZJzkx0dIUN+5nBYDRJns/+WapxbMaNIJAiTLqSPoQMfAcQuSF1Jgb3Ock3k68GQWCIoyd/GiSXljGwGJ10jmwKJICx1MrLaarwQ7iSfGwDyThiA8Hk+kri8D2FoLQ2WDCvovMO+k1luvmtNRxhsVZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EbV7CGUK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EbV7CGUK"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235842baba4so53968045ad.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220682; x=1750825482; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TiynHwWK8Tuc2ZhwblhQo9IFn5bKLScHdC3X2XmCKdY=;
        b=EbV7CGUKFzsbOJfs1DHelJelcylL40Oy7/B0lW+tF6i+l7klPhcQtQc9rg8x22A6D1
         6Xq9yg0T6dfxWDEz7Ejb/BToxmWs+U4RF9TKJO05R5+tWQ+mwF9ve3MTrBE8s0FXTDuN
         GuUEvvyX24XXOJpbFjtIChYC3SaT5GLbOzKV4ErsmqrEiKj7OdIe621ftVj7Q/5ioKDh
         uxUQSFvUsdhJNQBK/jgXYo/uQWeKlH6mVb9rlfy1OBUQko3EKssefmavAmgEQMz/f5ue
         W1qtdv8JX0faumS3L0HsDY9/0+R2+8Kf5jIMkUNcyv/VRnOrqZuAMspF47j4qq1Ejye8
         toXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220682; x=1750825482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TiynHwWK8Tuc2ZhwblhQo9IFn5bKLScHdC3X2XmCKdY=;
        b=CM7uD79Z86KU1YcYtnAATWVAceFaz8iqEU2luG12ehh7oMq6Kr7/olpsQuLsgRgho5
         acLQ39NHYgaLqy9/piN+MF1SHSF28n8mAwtx60mE98FeRMXRAh0WiiQ2Y3DkQvq32MC6
         imWSwePaRdfFkWfj+SpYReya9YiuM5ZmADa2+R/+sNwwKKVN6TtTjc9TOkrKgQ0dKa2t
         4KmXW54L3OQeQ8JT5AeNGRygiZoZxEJb7dgUfOfgHPKMScbKvUzKlEWVbLGIlrEwEvYZ
         Ym4vnzvwVvLJhyNouR1zguNwuoH/JVFPpVqu1r1ZxSxBL0uOmig9l/oyBlarGBWuq9Q2
         87pg==
X-Forwarded-Encrypted: i=1; AJvYcCW9HwhriMZasCB1VAgwrdC8g909g7AdlcLhL8MDyZTx9D3CIs6y3WHjuuoLgJjwzDEKBkcaRXU=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywe8SlbSa6SE3l41E3MKaTP6fDOI08vdOvz2mgQBSJNOHVM9ifr
	9N6eXogBMNkwnvrc7vT/HHdbvg/ACEVjqMrW1VrmxUedGgSC16emDSlOQ2vi+omK+LLaaxoBUi+
	5+rmqV1OjT628U9qKXa96aA==
X-Google-Smtp-Source: AGHT+IGRuVATub0VagSwSO594ph7F/RA6BsWrOduHNPJT0NSOVEpTFRu1SVjCYkpWfQ84SvEpdSv99cmJKRK2o6P
X-Received: from plbka7.prod.google.com ([2002:a17:903:3347:b0:22e:4bf7:1cb7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf0e:b0:234:d7b2:2aa9 with SMTP id d9443c01a7336-2366b1221femr249131655ad.29.1750220682173;
 Tue, 17 Jun 2025 21:24:42 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:19 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-11-jthoughton@google.com>
Subject: [PATCH v3 10/15] KVM: selftests: Add va_start/end into uffd_desc
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This will be used for the selftest to look up which userfaultfd we
should be using when handling a KVM Userfault (in the event KVM
Userfault and userfaultfd are being used together).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/userfaultfd_util.h | 2 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 60f7f9d435dc2..b62fecdfe745c 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -30,6 +30,8 @@ struct uffd_desc {
 	int *pipefds;
 	pthread_t *readers;
 	struct uffd_reader_args *reader_args;
+	void *va_start;
+	void *va_end;
 };
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 5bde176cedd59..31d38b3a9d127 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -152,6 +152,8 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 		    expected_ioctls, "missing userfaultfd ioctls");
 
 	uffd_desc->uffd = uffd;
+	uffd_desc->va_start = hva;
+	uffd_desc->va_end = (char *)hva + len;
 	for (i = 0; i < uffd_desc->num_readers; ++i) {
 		int pipes[2];
 
-- 
2.50.0.rc2.692.g299adb8693-goog

