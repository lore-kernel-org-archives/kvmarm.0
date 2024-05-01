Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6297D629E4
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563035; cv=none; b=FwnWjJohG3YQjAZa0aGbcDPy7RoKxKdeO2hRJHNmKGFd7Ap9OsRBGuQFFRCo8k4QvKfvwt+rHCGTFEVe7WV9YjlqoY8+45rH/f/jOPL29PfbmjLZIiiNuRx2enUZTqioD7LFFmUq71xyzFVijzG2vYwa/eyHdw2NLls72nFsXRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563035; c=relaxed/simple;
	bh=SBC9goY0qyeWaqVZEk5sqx6PBhg4VTZbRSRTA2YHwJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOC//BPcu/9H/9h+ld1Oa6PbhtW78cPvspo6NoRfUpPTXtN+b8UEZIS3ClXrQ7tj2OlaTSiTHHa02ObY/RVQ0hO3NTnIUK/wtDf3Z9uzmfLEHuac0/f7fzA26dTGuEQ/d+3JbxxL9a54D0/QRAH/w2JXep5vvLgpSk4wpu3c3Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bwjw1ERt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bwjw1ERt"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1ecc23e6c9dso416035ad.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563033; x=1715167833; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWoWbY1l8dnEVRR/nSiK5WHJ8+U9imW08rrrMnGNnqQ=;
        b=Bwjw1ERthocRgz+VMyr4LdSzJlV81t9LtE50rbSSiahD2d917rb3gyF8tneOGIsJEo
         tjntIBaiUvtmQ53naxtRn48/lv7p4MEuurVpfob5gStxuitDD1X8uG70cnEhjpNJIzbM
         pteL/mOiDA9FVvOHLRXOOyDBprd4LedIjrV0SQaJJhJVbda0K3d/YjKU/PkOc6w5F/0f
         KnDAksM1u6ExxM5F9cu/H/wCGGv1RFXCNkBkH8J5jKx+HAkTGDtpuf2NSQwlpGZKvpPE
         S61CmdY/XcLON92ne6jwBcXbGIPmkji0kpfkJ79Co4hgMDGY3zLsRdXEm+GMTLlQBTJm
         sxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563033; x=1715167833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWoWbY1l8dnEVRR/nSiK5WHJ8+U9imW08rrrMnGNnqQ=;
        b=JdNmyKjvHwgb3z3pQgmNMc1IdVJRncMEUn162QKBfFnHcglx19vSJP1bgrBoI0eYSL
         h/vW3Dw3W4zwZS8PHMlHR7MnlNzv8Q07R6kX+V7ooIGV7dan8JRRg6PVAMib51dHEwl2
         uX7YJAuPztLIq262qaZgEaXhOl42iO1VirGE0bNLY5syzrAPjdU/FgJA6hLcyGUaUqQ+
         np7AwzafhYMTllm1Jerc1OxozpzU9aYLb9OVMcLDB3y9owhUW5fc6sb+SSSrG7gLhkj8
         Og5hzVKGdbJJPC2/Sbj8EMssbJLMhsvhFnrOWKjP+Kg8/cVpPFZRpX/uSNsVBaRYeAQF
         bpHw==
X-Forwarded-Encrypted: i=1; AJvYcCX6jpgajzR1clqqgVCANCyupZfhZFb98fy6X72vkBG5nNuhknEOizSicXdxvSydaXVoRPtYkDG/VGMWRrG0ekiox2M+tJXX
X-Gm-Message-State: AOJu0YwE1Odq5AVU8NyKjodNr0+d4ys3Fbp3mryw0/3IPJAt+cSUcuct
	38XDJTleu+CUBYjzHlzaBALkEzfuw8nBxpDZltyU5RyeFuDAj7Eo
X-Google-Smtp-Source: AGHT+IE/3oHUP9voRIWXFZ6/QeBPDdS7lxxGgAJLR6S836NkCuvxR5ksBSEvpkvI+bsO729JuO1Kyg==
X-Received: by 2002:a17:902:b497:b0:1e8:9f46:c1af with SMTP id y23-20020a170902b49700b001e89f46c1afmr1887171plr.63.1714563033464;
        Wed, 01 May 2024 04:30:33 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:33 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 3/5] shellcheck: Fix SC2124
Date: Wed,  1 May 2024 21:29:32 +1000
Message-ID: <20240501112938.931452-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2124 (warning): Assigning an array to a string! Assign as array, or
  use * instead of @ to concatenate.

Shouldn't be a bug since bash concatenates with space and eval is
used on the result.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 45ec8f57d..95b6fa64d 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -150,7 +150,7 @@ run_migration ()
 		return 77
 	fi
 
-	migcmdline=$@
+	migcmdline=("$@")
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
-- 
2.43.0

