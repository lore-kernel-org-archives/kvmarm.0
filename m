Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49938DE8
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486110; cv=none; b=RJfa1+XmReoXN9hdMs8iz9t/BSXRG2XR+mKGsh5U5WCZSqbJc4XJH6RkCKn1Xo11qnLAcANvdbk1gYjHAmpY83UDmXCvh+X2iqRtmYyyCOq7QAG0FYePReDUCQENNjybE2HGHnBB8duBN6LRmSXQpBo9f+dDivVFfF6RiI9AarQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486110; c=relaxed/simple;
	bh=2LO805GcRBB/AS3N3iJ/k5e5Yj6b0xPw/uYIJm4sYGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfLpGvERwVnWUY/DKjGrAwnhRbdHKaSSjXzHE+bNu3r3rko3Pehroc2jAEJKEyLjhZs/MB+w379LEa0Uged2YfGmjlIMkzfPgaC6cYVF12O6IwUgJ+NNqqhgtmSKhN17C/GJGODgVDkAaIE5dTvegU+1eLCd/AdiEcbfR1WeAQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzyACj5t; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzyACj5t"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d944e8f367so50031065ad.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486108; x=1709090908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evUoa/UNV/oB4oPRxAOsnBRrgjlX2PtlMy4jxi9Yd70=;
        b=lzyACj5t2RNyJqwKBDjuCay0U2J+Kjky716/SOIrU74MMZMS3gUnqng3jn9HWD8LDJ
         yZ3Wa25cK5lMdF4O5WEvwpwtwUhg9FdecmPPJZrOgkeygZMMCa7dgbO65Ha3zIgjE1ms
         VfeIfZEpYpGeyrdgU4LtQVgfjxTsK4vQVKo4hGOqjgk7tdcSI7cxam2mFMK3yY1g/qW+
         3OC/jPQX6wb9hMC8CTXTA2uL1W++ETUsteE43Oc+0QBrWK56QYCe+lvd0Ajr6CuRQB41
         VJVDaH7sP0PRR6kd9iqnhN5StLwHeglDjKXTJH0+SRkh0BZ/GN896E2RNFviBPbE30ZC
         1hng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486108; x=1709090908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evUoa/UNV/oB4oPRxAOsnBRrgjlX2PtlMy4jxi9Yd70=;
        b=aHNoZsnNSaGUBFO6Z3KrN3vP/5DwwG9aqcBvgsslf8jZGdmnKaR0qrnB9lXbX7OVkv
         8uyx0dPy7FNMjFRQCbns0xdIaKXzqAh40Ngq0DEgtyxuy6ZdQYTbz2GYzwcLD2iAzXY4
         y/fPEYPGCiPbhllZ6owPJ9+aLz0X6QD8SPczd80Qftr7pgUjPzOGhFp9K+xgsvvUpH+u
         mv3JT5CQNaTnsASUWR5TR9wo7hu1APBAPmv4cQbMxmjaW0VoJMwe3awnc5i/B6klCrYN
         7KH3Ju29FLz1Cl/pmTaBRBEebdDZ4r5xzyAvqemYbN5SZoR17RoKYnejVD+3pZ/8sP0u
         MJmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyoCiOrZBAUOlwnJEkZe3WM2KnK67hGUE57NXWstv2LI/v0gjlOUE9x2/zDfc3WF8MPICE1VorSgDPAhRHeidTxYsp8iOi
X-Gm-Message-State: AOJu0Yx0NlA/+2oZ6XPTDY88fKn0dEbIcXBa/94nuFg0k55sjdepkEtT
	o0LZPr8lXevVX1OLrV7kZyx/GhCKye5RUyVCpoaPjmpEQjMMg/zn
X-Google-Smtp-Source: AGHT+IHLUAJXOt//4pQmY07Vj7IwKrIV54Fyb24iOQkYYZFJyUxY99z1JgYADhvTB6IxvrnEmb4LgA==
X-Received: by 2002:a17:902:6806:b0:1db:e7dc:302f with SMTP id h6-20020a170902680600b001dbe7dc302fmr6474108plk.17.1708486107833;
        Tue, 20 Feb 2024 19:28:27 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:27 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 1/8] arch-run: Fix TRAP handler recursion to remove temporary files properly
Date: Wed, 21 Feb 2024 13:27:50 +1000
Message-ID: <20240221032757.454524-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files were not being removed when the QEMU process is
interrupted (e.g., with ^C). This is becaus the SIGINT propagates to the
bash TRAP handler, which recursively TRAPs due to the 'kill 0' in the
handler. This eventually crashes bash.

This can be observed by interrupting a long-running test program that is
run with MIGRATION=yes, /tmp/mig-helper-* files remain afterwards.

Removing TRAP recursion solves this problem and allows the EXIT handler
to run and clean up the files.

This also moves the trap handler before temp file creation, which closes
the small race between creation trap handler install.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360a..11d47a85c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,6 +129,9 @@ run_migration ()
 		return 77
 	fi
 
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
+	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
@@ -137,9 +140,6 @@ run_migration ()
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -209,11 +209,11 @@ run_panic ()
 		return 77
 	fi
 
-	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
-
-	trap 'kill 0; exit 2' INT TERM
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}' RETURN EXIT
 
+	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
 		-mon chardev=mon1,mode=control -S &
-- 
2.42.0

