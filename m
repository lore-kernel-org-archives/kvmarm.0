Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0075C472099
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933054; cv=none; b=GfLiIzpcDStUneSxbn/a5iDvOIH+lOUTNMAzyraRdtHYZ1LCXKoNiY655CV+RY0RsFfQBlH3Nlvt0oBAMspmGttz/CbsQ6xVEnSXvG+LueVrquNb6UpxOJqvfueui7gDjYBJdw6pjT8/CILpCnq9Q+8DkfUcZlZCRluoG8ZG1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933054; c=relaxed/simple;
	bh=xr/NZJKBK6CUnL1RnXkkMJeJUXfe0jmUB3ZL22elyF4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN9ymychK6cgoDAmV4lsXJn0WC4bupYhzHNB50bvy0RuXn7xA3E7tz4y8gkZid02jib4pCxI8+Qgc2AlO/e07EjgK5Dx62A8T+ezJnCh4cKSZGrwSFKYlO1VISl37WhHE+oVFZbt16j0jZAFk1eTmwenwgjH3NY0Y1mnh1nzvw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=ktAkDIiB; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="ktAkDIiB"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aae3149so1690793d50.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933050; x=1790537850; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qTv8uFL1FYxhccWvDyiinfq9K+eUMO7fyy31bgvC6E4=;
        b=ktAkDIiBNQTomL4jZQXq6kbHOCoa1HOdmrFfqXrvhOgi0bMr7cJuGIpJvutBPZ+5t2
         lx5U6H5nDSbb6MOXuKtOAzSYz6u1sjNh0gXm1m1I3WBKt0fvSUULmZyZLkQlwxYVz05H
         zYHxJgagw2dlFeogAfQ/+TkLMLaF6KkHGMAqvlW/WsJBZvl+WKqao2zi6rK1Gp7pJuIx
         t8t9eB9qJea4IfqDoJYrmkD/v8OEXoNBPwST5MLAswoll9rrfMi9w/zDAvm/gypGVsZE
         U31nLoxfRyppudvgi4EpEUDMhi+XFumI/bnrVMeLLja+qafqwOSXLg+VHpFcRUxV8BMN
         giLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933050; x=1790537850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qTv8uFL1FYxhccWvDyiinfq9K+eUMO7fyy31bgvC6E4=;
        b=zbuQgtnqeemt8oyy394YxyY5q3Lw9QCQ/iGM8YtfaCmpakdQlr0TMbHdW248S1Eqf/
         zjZc/HTjYPElZufjTWEHDx2KOpFSuoSgCtbqyKqVLwR//fx746gyRJeVoxhnuj0tUSrp
         Yc0/W6opjkDObCUpCN3cAPyL6gqjyxAQOPQdo4n8EHreFsZ9hjd2YASQIV5DuPMe7PjP
         u/LsTq20fAd8sMtaGc5hgW/MnyOj7j9nHO5aznHK5jMak27bNvnQNMZNwrWrKOoTxXfM
         Uop9N/W8iqCEtjIPN/esE3x/BigNJnsDeiaXLb1ma+s+GFpRScS3V3VRdENqSgn2BocD
         SlzA==
X-Forwarded-Encrypted: i=1; AKwUvBzXGkqBlR6yWLjZU+lYGP/WKajAA9p24GdAvR3xAhEdtlig7S6x6zBsVhv4BmqEd6G4zWivc/g=@lists.linux.dev
X-Gm-Message-State: AFuF++ldY1NV7/c3IVKDZQQyXQmRly+ceKsW61svTK4NRbK37Cbkt8Vv
	dIJZ0UYderI7NAdlT8Mc1XtRc+z9MIibIl5MjtV/WZAKdGoDOLpAaurljw3blzTVcs8=
X-Gm-Gg: AYBFou1Odvxs5gYkMCC+GmM8emYIM2GKIu/cH2LUVaIoihYcsl4759cb5M7Ki8hlwEm
	3yS2eiGbN23wQLQJywFfpMj+7EKgAISg1W+wmdnqIvJNWot9T6EVrxD9LG+DuZ9OQqdOFx/1aa7
	ZyBAWXNR3Ekjnu8UyJjpaxd/aXvglyy0YSjsWVbxvJUtjFmXC0Sbr33Hxn4+ig9a+fd/JwwUuXo
	EEj9gAQZCLXf3dZ/qLA35Dw3YqroZtz4n8Jux7wNggvAvcvdu1PGRed8vOVfXcWW3mBp3YTFd8o
	LPBI02G9XivC1crVoRZEWOyZ+/Vis3cg+FXdU7dTfniuNUpZc5tb6COUM+Z+tS/7LPkJHp5S5zt
	NxwufqUt8Zrlas1MkhGa4mpm4zzD1bRxoABQRbyfHf9tp1h2PxQK/j33EKCA4XnjVyUcOe2NvF8
	FP0/8T9Z1WncqVz8S7i7DQnnoTIYiavKOEqd22X0bQ4pvzwBGVAAcFlkTzvv6mkemZif2QEPpnr
	vHGz5N3GbiuR9+vbb8p3UNoqIVD0APSRhxKF5Awfc9GS98Dnm547N1+vove3iHgKkOXalh89mF3
	doShHh/Hh5SXaXiW3KhE
X-Received: by 2002:a05:690e:134b:b0:671:70d1:d6e5 with SMTP id 956f58d0204a3-6717fe597a3mr2639510d50.87.1789933049997;
        Sun, 20 Sep 2026 12:37:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67298f64c7esm2656294d50.2.2026.09.20.12.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:29 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 06/46] x86/smp: Skip offline CPUs for REBOOT_VECTOR in native_stop_other_cpus()
Date: Sun, 20 Sep 2026 15:36:10 -0400
Message-ID: <20260920193650.3373435-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In native_stop_other_cpus(), cpus_stop_mask is initialized to
cpu_online_mask minus the calling CPU. However,
apic_send_IPI_allbutself(REBOOT_VECTOR) uses the APIC broadcast
shorthand when enabled, which delivers the IPI to all physical APICs
including offline CPUs.

Use __apic_send_IPI_mask(&cpus_stop_mask, REBOOT_VECTOR) so that
REBOOT_VECTOR is sent only to the target online CPUs in
cpus_stop_mask.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 985103cab16c..2449d15c6667 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -192,7 +192,7 @@ static void native_stop_other_cpus(int wait)
 	cpumask_clear_cpu(this_cpu, &cpus_stop_mask);
 
 	if (!cpumask_empty(&cpus_stop_mask)) {
-		apic_send_IPI_allbutself(REBOOT_VECTOR);
+		__apic_send_IPI_mask(&cpus_stop_mask, REBOOT_VECTOR);
 
 		/*
 		 * Don't wait longer than a second for IPI completion. The
-- 
2.55.0.1082.g2b9226bbc0-goog

