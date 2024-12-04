Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308061F03CE
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339667; cv=none; b=DzkcxAQO++PfJ6Ihg644VxnMznFcjMfq6MhX5CwFChjx4CjrzoubwyDUeAAJJX+8bWbh1RJH8+kCia3ClhtP1qXgk+S+5dlRYylevKQQ/fZusTqkPb2zpftX0pZHCd16Sk60cIIOvQbSE8J5qS6E7CC/LsdGqolfDZslBk8e+dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339667; c=relaxed/simple;
	bh=+IUtnc1DFoGPVy1DRFRoxmxu2aWJ46Lvmm6jdceQ08U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dw0+nif00QPwq6OMj+rf8MI2CO4JEbpyWGhltv/I7eNRFoPD6tK0iyK/RO9+DFxfo7OrqzAbS2YSKWdVhgNofhqcthukcGtgNQx810ZF5xfd47vxQdmvUweopb0CMbAhTKNF0ZbZK+CDQ4fFobHCBlGPNoN5HJOZwyJ92XhyN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gXJkqsh1; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gXJkqsh1"
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7b67a8cd4d2so19538485a.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339664; x=1733944464; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gP/1ZRcuFjEEMybT5UMVVNt/puu4fP/kE3PemhzVNvM=;
        b=gXJkqsh1eeNOd0JCp9ge4tSpeOMZoH50ClIoPkENSnRcvgO6lUSfgSGElIUO55xeOT
         erjZeU3/+n5mjjXgdpx7ZDRviESuArOFec8ZuqFQy93MxTp19JHjNHISAXMofx+iaLLm
         OeeUF+D4tbfm7xvd3zJOSu1yN9qj66rWyKh4wYhm9zVwZH48a7+IqaN5pH8LabpgCGZT
         p9ltkf+4KYUaRZmCGDaNUd3TGQeMn3cw6rtXbATxHllcwYoWiX/yhxqpic2+zxroNbPo
         pzce22gy33jpugBbVAaPhNLggavEdr112pcdvXEXFOL+4E26UBF4CJ0mniaNdTApGJD2
         BHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339664; x=1733944464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gP/1ZRcuFjEEMybT5UMVVNt/puu4fP/kE3PemhzVNvM=;
        b=XQZt4xNn0DczhnNvgdcZ3hJPbs5uMAeDFNcogcwkTULtTsxrBFpeNVziHua8hYYSKC
         RvYfaNKF3LI7iN6tB4eTqwcdOlNffDso/ymLv+3viDivJtdXgbNEPgFW+k5CIGdNotjc
         Zdoy7LgGntG/1ucccbJHxPMLpKc6IaEGkGDcqROUnAuMrntpYhDv3Wgc0tqZH6TsXgy/
         31sVYegdpnlg2QOiU8tV/M08gK/KjuSeR5z4GoMS1QbwqGzD7MLF8p6HWZ6qtGAmIQ7z
         OJhrTvT8gTbn8vSp1VmEfmJODp0EVb0d68NKQwxsFRSSG77nE4MSAmA9Ckyqr3fqFcWW
         YHgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTiaA/+Sx5P+th77/QGmn6cBJ0KN/+Jyaj1MclwuJZqA9XcqZc9/OdkfQEzUzUHWh9TbDilW0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQR+iYtYZMdswPJZ/ZI66nJA62r8DDIzqI1HSHdhnIGDPqvLCT
	/2m0lgpm7N5Y/wVp4c2iOI3lVjOhhc+u9hd4Hi8reGhOhB9/CfJmutBPYOUI/M+xW9fRCr4qmRy
	wvxgP5Y0rm/gjenwXcQ==
X-Google-Smtp-Source: AGHT+IGl8+Y6jXlfDxpaeYQWcz7MkBYaeVCfdRzcMWgZ4EOOrzmqxMS37+BVzh9ZHq4dtxMyhyVDFBoslVL+V2Wp
X-Received: from uabih6.prod.google.com ([2002:a05:6130:1f06:b0:85b:c307:6bbd])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:44c4:b0:7b1:52a9:ae1a with SMTP id af79cd13be357-7b6a5d2aa5bmr858557685a.4.1733339663968;
 Wed, 04 Dec 2024 11:14:23 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:44 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-10-jthoughton@google.com>
Subject: [PATCH v1 09/13] KVM: selftests: Add va_start/end into uffd_desc
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This will be used for the self-test to look up which userfaultfd we
should be using when handling a KVM Userfault (in the event KVM
Userfault and userfaultfd are being used together).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/userfaultfd_util.h | 2 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 60f7f9d435dc..b62fecdfe745 100644
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
index 7c9de8414462..93004c85bcdc 100644
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
2.47.0.338.g60cca15819-goog

