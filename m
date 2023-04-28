Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C253239
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:00 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45917139F;
	Fri, 28 Apr 2023 05:05:44 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53EE43F5A1;
	Fri, 28 Apr 2023 05:04:59 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 10/29] devicetree: Check that fdt is not NULL in dt_available()
Date: Fri, 28 Apr 2023 13:03:46 +0100
Message-Id: <20230428120405.3770496-11-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

Up until now, for platforms that support DT, kvm-unit-tests would
unconditionally use DT to configure the system and the code made the
assumption that the fdt will always be a valid pointer.

On Arm systems that support both ACPI and DT, kvm-unit-tests plans to
follow the same convension as the Linux kernel: attempt to configure the
system using the DT first, then fallback to ACPI.

As a result, the fdt pointer can be NULL. Check for that in dt_available().

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
[ Alex E: Minor changes to the commit message ]
---
 lib/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 78c1f6fb..3ff9d164 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -16,7 +16,7 @@ const void *dt_fdt(void)
 
 bool dt_available(void)
 {
-	return fdt_check_header(fdt) == 0;
+	return fdt && fdt_check_header(fdt) == 0;
 }
 
 int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
-- 
2.25.1

