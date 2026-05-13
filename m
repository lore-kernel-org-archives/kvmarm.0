Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2723A9DA4
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778706989; cv=none; b=jPF6CSn5OoyMxH1LU+6im/WWwclwI6nL6lhlz9dq4eIXilfOQw1+ZuCdjQwJabAZE3N8Z0uLblLaVJ2+krXRDbDVOulz1+Wy6oqPAe/vysA7NNcrp4k3ivsLsG5/eLieWzECK8HT/mnQnxMBTG3OBzoiXK4mrdVoyD5HXyx16/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778706989; c=relaxed/simple;
	bh=jKQ8iuhXGvRDVAnzj1gC6DLK91R18lf4SB4H8czhV5A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mi0mGc35FmsOr1jlgy7u09uKc0aZ1McxVG/2kETdE1qLWaw69PqAObfTHojHIDxMzk4116M8D6XKkjBAEBLi8/j2kKaTwlPflWbaPNwilGd2+88x4OtFFJD31rGcZVb7Bsc6gDcJANDIzKb5YbhabWTwYC3Ht1JyzLm2oK21TOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jwbfI5Gc; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jwbfI5Gc"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-69b4c167215so8676702eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 14:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778706985; x=1779311785; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6JXnGk6v8vsVrC7dHkuW3HoXav5Obr9bfPUm82eBukk=;
        b=jwbfI5GctJkxuBRSd1Ge3TLGHTJmnwReyWHwHG1KvmaLl+KU1FogjibQ3mSwF24dNJ
         zxsHiq5LXmrNeZY0/0RQU4HXMziV99PIYpvbxeckOp7LrcUmmNeD1T6aqyOIdcPOlfNb
         UZcH+G4IsQmYnaH8hE+esEa0031wtJw91GRtC8cRcyHy/N32ocfC71HKV8hPP/CXqdw1
         /kGFqwEWAMjY6JmXLFhkZljbk/tc736O+Xf7LyI7N04XN8To0LWJ1i1MJMxW74sNWmb4
         TyV719Ec4UXx0esOrGKj+H+g+oNSKddZigcJy/ops99KzTJFzQ86HW8cUwykt3J/Voii
         7C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778706985; x=1779311785;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6JXnGk6v8vsVrC7dHkuW3HoXav5Obr9bfPUm82eBukk=;
        b=A7OVsCOa+GFflcdEHpNtXjRnxzThmFD32nI+0kBb+840SqGjauDM665tWvI6S4pT2R
         RQmNB55dWjvwRsQTbUguHa9ngrnJSjeIK2ZmWLvmu1im4NR/WJ4RcCj4l/okLa+x/VM8
         837VNxPOBdkuVoXgrpkY1Pg/E438TtYbkMAkVPT24Muab5lu5kNe0a89GdFzuQXBR7MG
         i7U+vAcHG+bQuXFZtybDfgPusm4u0xDL2hdW16dQU858d1edq8EjIP/cmIoteu41MuQz
         E4AdtoOJc3173lQrB1zjFSd7fOchNZe0WrqroHtyu8Y7xWgyu1JA3vaeydtny87i+gRs
         Fh4g==
X-Forwarded-Encrypted: i=1; AFNElJ9BoM5gwm0DSTRUb0dI6kuJ82inH5Tz/E9vhQnBpy5PoeYR+r3savv2597+ISqtxVl93fpNEf8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm6HBmM5Ww8L8pVgnbrPVnaIpbL6JbXRCum9gXzVMtdv0cVmjI
	TYpw+8BJPqj3sJZ0QAFcryi7CxDq+xET1c+qXigzzMxJr1LS1y6tTWwc3ZWN7TtFGzNuqMV3n73
	yPIBd/Fb+JEMpCRnYFb74hXoIFQ==
X-Received: from iln3.prod.google.com ([2002:a92:d03:0:b0:4fb:4caf:c442])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:da01:0:b0:694:95ae:c546 with SMTP id 006d021491bc7-69b87d2fec1mr592304eaf.2.1778706985183;
 Wed, 13 May 2026 14:16:25 -0700 (PDT)
Date: Wed, 13 May 2026 21:16:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513211624.2416284-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] arm: io: Set is_pl011_uart flag in ACPI initialization
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When booting via ACPI on ARM64, the SPCR table is parsed to initialize
the console UART. However, the code was neglecting to set the
is_pl011_uart flag. This caused __getchar() to fall back to treating
the UART as a 16550A device, which fails on systems with a PL011.

Tests that wait for serial input (like its-migration) would hang
indefinitely because __getchar() would always return -1.

Update uart0_init_acpi() to inspect the SPCR interface_type and set
is_pl011_uart accordingly. Also define macros for the first four SPCR
interface types in lib/acpi.h based on the Microsoft specification.

Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/acpi-debug-port-table#table-3-debug-port-types-and-subtypes
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 lib/acpi.h   | 6 ++++++
 lib/arm/io.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/lib/acpi.h b/lib/acpi.h
index 66e3062d..29b3edd5 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -251,6 +251,12 @@ enum acpi_madt_type {
 /* MADT Local APIC flags */
 #define ACPI_MADT_ENABLED		(1)	/* 00: Processor is usable if set */
 
+/* Values for interface_type field in struct spcr_descriptor */
+#define ACPI_SPCR_INTERFACE_TYPE_16550		0x0000
+#define ACPI_SPCR_INTERFACE_TYPE_16450		0x0001
+#define ACPI_SPCR_INTERFACE_TYPE_16550_32BIT	0x0002
+#define ACPI_SPCR_INTERFACE_TYPE_ARM_PL011	0x0003
+
 struct spcr_descriptor {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 836fa854..55102bd7 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -81,6 +81,9 @@ static void uart0_init_acpi(void)
 
 	assert_msg(spcr, "Unable to find ACPI SPCR");
 	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+
+	if (spcr->interface_type == ACPI_SPCR_INTERFACE_TYPE_ARM_PL011)
+		is_pl011_uart = true;
 }
 #else
 
-- 
2.54.0.563.g4f69b47b94-goog

