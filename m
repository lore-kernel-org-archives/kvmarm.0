Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769231CF9E
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="K8ajnGCN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7LtfXe/DEMD/lHzUFvMa+OWRluqZ+xc9nu0Cirekhm8=; b=K8ajnGCN3VL45r0nzCQRkKqgwa
	uaygU4jSLCNphjhbsSYH8Mw9uxK5T31L7XeD8pTVWCGk8CcAh92YnB/TfUR7mKBwJS80swJozBKlr
	eXnE7NkUH2skU9CMUPuNlc9uT+khCy+DZMe8tMiuhfaky/jhewxrmnVNLFl4PLGi3Ts+qGGViLz63
	RHZ2qOf2UeyCHJH5jmS4hdF1X4lUg8k9JphXTk/Ri3v4uOjEAQbWq7MmvzWNDzpYZwW6Oi1Dkh12g
	O64D98spVaGRJRVcmlWvEiofQPLj/uLdDB7UiqT7+uWqgU0iJlxN7OV57bjSvVAH/KLob5pF8ud/G
	uKT/B9gA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55754 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1qtq2V-0000UO-0z;
	Fri, 20 Oct 2023 14:59:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1qtq2W-00AJ8T-Mm; Fri, 20 Oct 2023 14:59:48 +0100
From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:linux-pm@vger.kernel.org,
	loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: x86@kernel.org, James Morse <james.morse@arm.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
	justin.he@arm.com, "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Use the acpi_device_is_present() helper in more places
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1qtq2W-00AJ8T-Mm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 20 Oct 2023 14:59:48 +0100

From: James Morse <james.morse@arm.com>

acpi_device_is_present() checks the present or functional bits
from the cached copy of _STA.

A few places open-code this check. Use the helper instead to
improve readability.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Jonathan Cameron suggests "Pull this one out and send it upstream in
advance of the rest" so let's do that. See
https://lore.kernel.org/r/20230914130455.00004434@Huawei.com/

So, let's get this upstream to reduce the number of outstanding patches
for aarch64 vcpu hotplug.

 drivers/acpi/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 691d4b7686ee..ed01e19514ef 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -304,7 +304,7 @@ static int acpi_scan_device_check(struct acpi_device *adev)
 	int error;
 
 	acpi_bus_get_status(adev);
-	if (adev->status.present || adev->status.functional) {
+	if (acpi_device_is_present(adev)) {
 		/*
 		 * This function is only called for device objects for which
 		 * matching scan handlers exist.  The only situation in which
@@ -338,7 +338,7 @@ static int acpi_scan_bus_check(struct acpi_device *adev, void *not_used)
 	int error;
 
 	acpi_bus_get_status(adev);
-	if (!(adev->status.present || adev->status.functional)) {
+	if (!acpi_device_is_present(adev)) {
 		acpi_scan_device_not_present(adev);
 		return 0;
 	}
-- 
2.30.2

