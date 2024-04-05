Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2AF15FCE3
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307810; cv=none; b=ejd7ykroVtr0crzaUH+2TwcvvVNA3fp62P89LQXHdcjkFyS45kGthgjInexkMGdG+qgE6OLs5fvAavxkYrAMULt2NKpvA8GJheW575hshdZt6r5T8hykTiyeGHm5NTMw58x/ikowvnuqFiFCS7dzDvIwcT0RLtduVDNbsPA0haU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307810; c=relaxed/simple;
	bh=OSqsyeBYuUgPPx4PzD0nDj2h27raEgPA3BttTW7g4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIn3F6NkcrwyOshdPES88jgYACJ7BhB4zvSlMFPQsgHhBNxI0SIr6P3gTK1yNQKo1+9FM9neUcSdkuqoHf6J8RgYcPCHU/68ON5vEKTNjqNo78k+lzcSFe24V5ZF4BpoAy1EuzbwcDI5Tigwr8GY2zo1xMqlFNv9nHBbK25Ujqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l51VOUOs; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l51VOUOs"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6eaf1005fcaso1430389b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307808; x=1712912608; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6QzAi7vCknWCSn8NS2P26SXGhMEhJFXPF1hl6gc7nk=;
        b=l51VOUOs/UdjDQL7JfzRYSK1dKS1b6kqGUebH4SYTt1g5tNseReCqslo+0Phbug+JE
         77yJzfuXlXj5ufL8M756i2bJ7KXjWeSbe/+4M17+3qY4MCq2+3mF5ad4jW83ULBNpMrf
         EXgunMlc2/PwbNF7BURJ2SAYpvilRzA1C8NVmr2IR8x8XdzVPEeaHiiJ2uaP6CMJbYw/
         NJ9r+xSQ/AWs2llQGWc8EXgKl2NTro92B3z63BRussvziQu5IP54DZn4X//JiqUlCmI8
         qQzM4V5AVQTkr2Tdm1OtR4uWJALqPmKjDDVxHETb0y9rVC6w2xAKKxHwH+VbMAEvv/fj
         B66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307808; x=1712912608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6QzAi7vCknWCSn8NS2P26SXGhMEhJFXPF1hl6gc7nk=;
        b=T/QgxFznDfRapzGn4LkS6XVxZGR7IszyVmT2+aF/f+FO6GBHjrMXYt75T3UTOprHMS
         ClkYTmpbiYI3gLtXCJnxMCGyrsmG4VIeYWh+zJei5GoHPDgbo3A51vnaesIEF6N5lzkl
         KWB2um0cXtE9Cc4CEbRiKq0L/OkePhpu/9nkJoadX6N51+9/8vetcTmPVKAD7Awru0pO
         8DtC5O7l7m4P8BNHaHd+WMn20XMcSpWuYAyqqK9dZK1kKCxKDdyRgA+cCto8foeNRebR
         Veozq8J5VIYzjRHrJw5PJTys5c+KSkGIyZtalh8B5bsuhbjNUFA0kE+CX9q1/6EWND2i
         a0Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXQkaauAqv2O1zjha6S5vZofwSpDv/ccSuw0Mh+QkRczgud5w9fh0q3X8ARD9dINz6xrSc0pYRUTBJY1TEqhZCVtwlVd+Ow
X-Gm-Message-State: AOJu0YxTnHvogFmDqUBaobE+kdGbeDQAVkeOJiWJz+op/mwXnbFizy/f
	0Vvgvvvgfbed/d/4axKionvxXaplZt0dHp3di5RPcMHD3etoZgWb
X-Google-Smtp-Source: AGHT+IEIbvzhR4Vb46KhNonnfT+UvilCqW0L9youNLHT1B8fzSApy5lkKFatECJ6OHe0njlNIb7qaA==
X-Received: by 2002:a05:6a00:809:b0:6ea:f392:bce9 with SMTP id m9-20020a056a00080900b006eaf392bce9mr862456pfk.15.1712307808567;
        Fri, 05 Apr 2024 02:03:28 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:28 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 16/17] shellcheck: Fix SC2153
Date: Fri,  5 Apr 2024 19:00:48 +1000
Message-ID: <20240405090052.375599-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2153 (info): Possible misspelling: ACCEL may not be assigned. Did
  you mean accel?

Looks like a bug?

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/s390x/func.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 6c75e89ae..fa47d0191 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,7 +21,7 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
-	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
+	if [ "$accel" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
 		return
 	fi
 	kernel=${kernel%.elf}.pv.bin
-- 
2.43.0

