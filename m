Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1471B10A05
	for <kvmarm@lists.linux.dev>; Tue, 16 Jan 2024 06:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UESuWJ9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1suPXz3mdXtEizWNvumgqR5PbxuamTx8eG/JhmK4lwo=;
	b=UESuWJ9rfOiwVcZnUpYJrfH8cH5UVgJQ04Mxn4zPGzEJPmNSIr58ULP+l6MsO6L+G5oIHV
	wOvhJoIciZYHevedBmM3phvg/Sv+Xw+/TnSxkRXBSU5AuBFQfqgVrdS0OCi4pUZk4yXFr+
	dicBqG4NBn1zC+0sLdifavwGdCmonQY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-tOW6xBHVP1i3VNj_4DXQGw-1; Tue,
 16 Jan 2024 01:58:49 -0500
X-MC-Unique: tOW6xBHVP1i3VNj_4DXQGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2E5A280FECA;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 929CA3C25;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/3] arm64: efi: Make running tests on EFI can be parallel
Date: Tue, 16 Jan 2024 01:58:46 -0500
Message-Id: <20240116065847.71623-4-shahuang@redhat.com>
In-Reply-To: <20240116065847.71623-1-shahuang@redhat.com>
References: <20240116065847.71623-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Currently running tests on EFI in parallel can cause part of tests to
fail, this is because arm/efi/run script use the EFI_CASE to create the
subdir under the efi-tests, and the EFI_CASE is the filename of the
test, when running tests in parallel, the multiple tests exist in the
same filename will execute at the same time, which will use the same
directory and write the test specific things into it, this cause
chaotic and make some tests fail.

For example, if we running the pmu-sw-incr and pmu-chained-counters
and other pmu tests on EFI at the same time, the EFI_CASE will be pmu.
So they will write their $cmd_args to the $EFI/TEST/pmu/startup.nsh
at the same time, which will corrupt the startup.nsh file.

And we can get the log which outputs:

* pmu-sw-incr.log:
  - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
* pmu-chained-counters.log
  - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'

And the efi-tests/pmu/startup.nsh:

@echo -off
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-mem-access-reliability
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-chained-sw-incr

As you can see, when multiple tests write to the same startup.nsh file,
it causes the issue.

To Fix this issue, use the testname instead of the filename to create
the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
EFI_CASE in script. Since every testname is specific, now the tests
can be run parallel. It also considers when user directly use the
arm/efi/run to run test, in this case, still use the filename.

Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
makes the script looks more clean and we don'e need to replace many
EFI_CASE to EFI_TESTNAME.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/efi/run | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 6872c337..2c34e3d6 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -25,6 +25,8 @@ fi
 : "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_TESTNAME:=$TESTNAME}"
+: "${EFI_TESTNAME:=$EFI_CASE}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
 [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
@@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	EFI_CASE=dummy
 fi
 
-: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 mkdir -p "$EFI_CASE_DIR"
 
-cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
-echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
+echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
 if [ "$EFI_USE_DTB" = "y" ]; then
 	qemu_args+=(-machine acpi=off)
 	FDT_BASENAME="dtb"
-	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
-	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
+	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
 fi
-echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
 
 EFI_RUN=y $TEST_DIR/run \
        -bios "$EFI_UEFI" \
-       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
        "${qemu_args[@]}"
-- 
2.40.1

