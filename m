Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDE1A71D
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzJ7VcQw"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-28b06be7cf6so1175843a91.2
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253087; x=1703857887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=XzJ7VcQwkPU+Yb4CEc9M8sTIIoA7GGGOV2j1pkWAIsBW5i8aAroGKJDlpzW680HgUX
         JK588N2ckrGVC/pI5amgS8wBScEgWwW39hUPoY0nWpecVYgAEKMb11qzhXPLr+EnBOkc
         OttwtsuyJNJNEWBGgvt0d2ybCbACI7B0Z/D8OVfxi4vL+SxnRcbGkAQiLG1Ysu6wz4tt
         YgYeEZ65RsDkupvfp0crcDNwOwITXqTQI6CbZ9pf6AzDpDzuVOryA0d3p/sVbuV7TMYY
         zIPMLrQIOqhN1RGvVLSAi2UJqR+YdWOfPlHl7f2VYpG/VO/Cyp/G6P87clm1C0abvhyU
         CF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253087; x=1703857887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=SAzK0ShWE+qeQ9XMG6+qQNAS8NoaPhUnGpVSStLDwDzMdG8orxffdNwbrFdZqIi0aC
         gOnHm7qbzVcpIjGsitK33WvV97TsuqSxLvjh0QuU6bPYcXtLyNhhjoRNbUoKDdWcwlx/
         byX9xlBDi0TSlTgugJkB0mjNHcpuf3HL6BaxavLskJezdMg0YhlFSlZoEO18EdNNPl+B
         zS9QvMRPxlpEthD8ct+y6L5MpyfR3wIVjLbS8KwA+oGNeTYwAkuZ9F4bbtR1Ze5su/6O
         dcQvmLNj2ssWAuun1/VHjrZxxmKjVGTQVi1olRsr8rc27GrHnUpYNJsSEhBwtnnySgxI
         he/Q==
X-Gm-Message-State: AOJu0Yw6H2mOKZS6LtHa0Oo+BWCl/n2JmeywFyYp85gNQtqqSQmzQrDW
	09N+jbndD6vUCfUOT8/z+GQ=
X-Google-Smtp-Source: AGHT+IFxYHMd3mIJhG2htlTQipJ7HFZrRdouAmWJJ2UmxbUBkbfOshxr2F261fmorF3DjDY21EJ+3w==
X-Received: by 2002:a17:90a:158f:b0:28b:bf26:3ba8 with SMTP id m15-20020a17090a158f00b0028bbf263ba8mr829664pja.6.1703253087364;
        Fri, 22 Dec 2023 05:51:27 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:26 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 3/9] arch-run: Clean up initrd cleanup
Date: Fri, 22 Dec 2023 23:50:42 +1000
Message-ID: <20231222135048.1924672-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f22ead6f..cc7da7c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,10 +271,20 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0

