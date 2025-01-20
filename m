Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900821EBA02
	for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391432; cv=none; b=ND7VQ0abj/fcRPlB8C2ZfGWQnr5VOml/AnM2kJ88evUWUNbsRSlkagdZR5G74KB2pIYLGnl7jiGl2uDIzJ6fKPCxIe/LZ8UUMBL46003wTmFEzUjj7UYxZWQsSJ6hczKBXRHUX2ZKGSJo7hAKYIMfpyhiFBDrKerz0uwatEkuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391432; c=relaxed/simple;
	bh=btUNxg9BkB+Z+r3FmdDIjdI3aDp8cLqkNvOD7MAjCEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY6JJDkasxS1t9kh5xtJh0gxB7ge+b5ljVzNj7Obr33kNeUaO0ZdR4AAUqudOmx55spJLY1dI4qEB5Qb1j6n9BMwRP8xkL5t7bwyN85CUduUCBhKNszpo3wmFkNQHZ4ODlu9awilMqH5wCfbodpl9pixpkv71EOSjyn++nQYKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 500531C0A;
	Mon, 20 Jan 2025 08:44:18 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C4353F5A1;
	Mon, 20 Jan 2025 08:43:46 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com,
	Alexandru Elisei <alexandru.elisei@gmail.com>
Subject: [kvm-unit-tests PATCH v2 05/18] scripts: Rename run_qemu_status -> run_test_status
Date: Mon, 20 Jan 2025 16:43:03 +0000
Message-ID: <20250120164316.31473-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@gmail.com>

For the arm/arm64 architectures, kvm-unit-tests can also be run using the
kvmtool virtual machine manager. Rename run_qemu_status to run_test_status
to make it more generic, in preparation to add support for kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run               | 4 ++--
 powerpc/run           | 2 +-
 riscv/run             | 4 ++--
 s390x/run             | 2 +-
 scripts/arch-run.bash | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/run b/arm/run
index 6db32cf09c88..9b11feafffdd 100755
--- a/arm/run
+++ b/arm/run
@@ -85,9 +85,9 @@ command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+	ENVIRON_DEFAULT=n run_test_status $command "$@"
 elif [ "$EFI_USE_ACPI" = "y" ]; then
-	run_qemu_status $command -kernel "$@"
+	run_test_status $command -kernel "$@"
 else
 	run_qemu $command -kernel "$@"
 fi
diff --git a/powerpc/run b/powerpc/run
index 27abf1ef6a4d..9b5fbc1197ed 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -63,4 +63,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
 # to fixup the fixup below by parsing the true exit code from the output.
 # The second fixup is also a FIXME, because once we add chr-testdev
 # support for powerpc, we won't need the second fixup.
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/riscv/run b/riscv/run
index 73f2bf54dc32..2a846d361a4d 100755
--- a/riscv/run
+++ b/riscv/run
@@ -34,8 +34,8 @@ command+=" $mach $acc $firmware -cpu $processor "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+	ENVIRON_DEFAULT=n run_test_status $command "$@"
 else
 	# We return the exit code via stdout, not via the QEMU return code
-	run_qemu_status $command -kernel "$@"
+	run_test_status $command -kernel "$@"
 fi
diff --git a/s390x/run b/s390x/run
index 34552c2747d4..9ecfaf983a3d 100755
--- a/s390x/run
+++ b/s390x/run
@@ -47,4 +47,4 @@ command+=" -kernel"
 command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8643bab3b252..d6eaf0ee5f09 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -75,7 +75,7 @@ run_qemu ()
 	return $ret
 }
 
-run_qemu_status ()
+run_test_status ()
 {
 	local stdout ret
 
-- 
2.47.1

