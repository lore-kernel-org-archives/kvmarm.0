Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A252797B7
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748355891; cv=none; b=nhlycHv2yB0LhwgrISPD1SBkthuCpGORKUd93anrFyqNWSnsPHfViTnHokYIhl62hYzilynkHF11y0TDPdpZHfQcxP25jdd8OWJwa5RZN+rOaj2j3WunhkrmTpEVKu30t1jf18pkYAxfxzY7ZrRcdwROFYjtfSqOldSRijPRG80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748355891; c=relaxed/simple;
	bh=VzQyPkruYWrDZAOkmL/UT3N0xShjKnGR9pQJo0jQ/Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=s3UMFYt4uwZoI5rehotDMLIhKi/y6daIYtTCHtmhVIyyIKi4f6APx6yTqBAXd5hXClz5tYHA/FAIbYXzdaOzAVlaKulgRZOqViSCQNRh2aC/KFGWJ2rodiAAqAso7aSHBOzKdT7FGQQ0hWw9mybMqHmqG60Aff2wi4At6rKyMZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjPz2drY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjPz2drY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748355888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
	b=NjPz2drYMX3azhD6B1mfv3kkIBqZhgPRgi2zxiCFGtNyl9Es7sATklshDfZDhsW+3ojEJ4
	34ZyiI5RZ6fmmivcD8ZfB3CugAoiJ+0gh6M+KHXYOqLCqk52uZhh2kT8Q6Lf0KNb0Ru0zs
	RC2BEj/xsmV2OeEUDvZNFBhWL5VWAmk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-eyY3zgpKPF2VfrsRYxBxtA-1; Tue, 27 May 2025 10:24:45 -0400
X-MC-Unique: eyY3zgpKPF2VfrsRYxBxtA-1
X-Mimecast-MFC-AGG-ID: eyY3zgpKPF2VfrsRYxBxtA_1748355885
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442fda1cba7so16181635e9.1
        for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 07:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748355884; x=1748960684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
        b=mkNcXyJHSRVNd048KjUn390n7cgbdCyRFymQBBdLQcylrpxTpYhnhm4/q7WuFXka03
         dSNBbMOXvIVzBHi8amVQPYgtCP2cMfe8igZCZkL0zw/UFqz5T2t+SDXB3+v0Ad+qPTnb
         BgJLG3KbVhxlVKkJ27qxNNmF748/hqAk+yp+uJeoEV+yypeYjyU/G7yaFOdvDFVXSI/L
         nCyKVg04g0F/JSZpf5HpUh1NXiKlpubVtP9SWbTA20eciWaJIRGQvxn3qq2dScZRN872
         r/f2VDt5h1ck73f6hO2v/48Eqj6owARFUPfB5g3x33ZWQA0Slkji0UG4rfrTfq4XfeU5
         eXgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTX+GKQ/0Eac8pjl1Makzv4iD7QIp8w7VcAAUl/R6pYM/4Eotq1wA8zRVE/XgsNyMlgoU5dF4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yybz1Bhrfa0mhQOJ+ohk+7Teywb3SHzzTuvuWqQEZN4ynS1qHpH
	kcGDKB5y61Y2Ysus9zmnf/rDAV+xs0htPO+q+73pP8DNPmh5B+aKYFiFKWpHuTf3oWyts63A5mm
	AhkQIYfsHGm83bZpMFAmSLREjHFGgyhcjqKFWGy8QMOLIo4BZ3b/LilB9Pw==
X-Gm-Gg: ASbGncuBmiS3JJtNG6VIrT+9OyFfRpA1Fe4R1cITQDESEeAsOeN6Jfsi0zVTubfD0E3
	xkDRH2HC7scdlVUq0yoC2jTMj5o/p+NU1BpXlERLr/qqXW/G8EbJveqmw8cfVQH2jWgX+p0gTyz
	JO88VlksAriVn7Z+m0Fd7Wn5j6nGRjPcWOfDXijAkOF2eOjwgE+eKrmQQ31Ua2ueVQ3pAHqR4n3
	EtHLKKrQboFl+0Mu/jW+roz5H7OqErXgaVqSguVWCXWGHYsDcQiC2gzF5xPiyZaSC4BY7I5jivx
	jLp5hPFcrEr3KUFMdMpt6Llp0E803LNO1C9jGnkBirE0eCYnTFXjY89yGy2Mxm7BtKxW5A9o2Q=
	=
X-Received: by 2002:a05:600c:35d3:b0:43d:4e9:27ff with SMTP id 5b1f17b1804b1-44c93016587mr106055905e9.7.1748355884577;
        Tue, 27 May 2025 07:24:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA8HR0A+QTW5CLIzzWpCQrdDEVxcSOCyoGFkafJofsp5nJGXbEA7AFPSlzJnet1RbsnO2sOA==
X-Received: by 2002:a05:600c:35d3:b0:43d:4e9:27ff with SMTP id 5b1f17b1804b1-44c93016587mr106055565e9.7.1748355884133;
        Tue, 27 May 2025 07:24:44 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d3edcsm278766415e9.20.2025.05.27.07.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 07:24:43 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 1/3] KVM: arm64: selftests: fix help text for arch_timer_edge_cases
Date: Tue, 27 May 2025 16:24:32 +0200
Message-ID: <20250527142434.25209-2-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527142434.25209-1-sebott@redhat.com>
References: <20250527142434.25209-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jnD_wp-FmmxhKH3oy970MxWvATRvKzIXqVAQoR1gkgI_1748355885
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix the help text for arch_timer_edge_cases to show the correct
option for setting the wait time.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a36a7e2db434..c4716e0c1438 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -986,7 +986,7 @@ static void test_print_help(char *name)
 	pr_info("\t-b: Test both physical and virtual timers (default: true)\n");
 	pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
 	     LONG_WAIT_TEST_MS);
-	pr_info("\t-l: Delta (in ms) used for wait times (default: %u)\n",
+	pr_info("\t-w: Delta (in ms) used for wait times (default: %u)\n",
 		WAIT_TEST_MS);
 	pr_info("\t-p: Test physical timer (default: true)\n");
 	pr_info("\t-v: Test virtual timer (default: true)\n");
-- 
2.49.0

