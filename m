Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96C130FC22
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668213; cv=none; b=f3Gf/j/kvfU7/OXBz07a1VVLz/qQIVVaaDMIcZO7gtu3suoSr8TTdvzHA5VmVrB87ddJM6ekcSEXPbBmohhIKWJU1PDzxA6ALnhpnmd7IAvRGj5PzBuzGIQPRzSoyi6/0COu7HmJn2kLe/fhFP7F3KamI//VC66mjoRmjA/JC98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668213; c=relaxed/simple;
	bh=RLZlk8xFEYP1he6P2etQc9IP6fyKVIbhnhFBzANhQEg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D2ZqZpRAn9juVX7wW4NmBlSBWnm8E7k9l5yrmVnZFlBqlmBC+/P2FC4eAeemmYlK2KAu6jP3nOEOSnl+G8IjK49YnrxrqUrMGPGlLLDj78zrqXXkI5wxVTKy6+G4S4kpMoz6/a+uBkhJ1jsjlCwnqKCBqi+rluZzoBD62/Yzvko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fWmof8zr; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fWmof8zr"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42e2d02b528so1728961f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668209; x=1765273009; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSppY5oK+32CD0itjrNWAYgn4J0yGPHY1rA0h9HSTYg=;
        b=fWmof8zrs4WVUKXGBhmwlSsswMeO7TBCGkxk8pA2dRzyKkYmERhZjsnH1PRH0dUFr2
         zDlbHRMGyIJ5tqQOeS4batJuEd+UG8xJAJMyivuhML1qMLusleQcYbtzNxd12uVSI2Y/
         AiHi/XAtQ9UMPj2Z/CbMyOh3Iagxpa3Ry4Of827b624+GxoZGL2RZxFDqdYBI2El3rPB
         rX//8gJsUTXUb11geQlWbMUUS1CoC869bvs4ol/DltPD2mXOPc1J+xRm4QVK+YrL9r57
         avQQhftltv5Q3unTjNLLNH7kLXjs/D2SR/euiFkHfkfh/SOoDAdre6cK9VrRpUE1op4J
         iwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668209; x=1765273009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSppY5oK+32CD0itjrNWAYgn4J0yGPHY1rA0h9HSTYg=;
        b=FJTAWSX5zNRjzj++XiiYyahopCh6TWgyiiPPzWbE+B9Sw9H8H0N55CoQTVxACE9A2n
         seBk3Zb4BcWTPFWedWDrvlmU56CBR37kn0WRanSzqpq32n9MjyBVn/Jw4kruGx55c8Ka
         urMZ73F6MRmqR9KoypYKu3DoxTVmRuwn4WYVhIt/Rol8HtGa8G4yenl8aL9KJ6x9e4gL
         zKZGBANleZJtnDHeaYXlP/Cd40GsLQvDwCYc1GjVOYlatn59DVlFLAB7ij+0ZMIQKTWE
         5dveA21OvIV7ffHDCNiJxwIK58ylJ5y725Qs8yJgyVfbGW0QejGgVzZYiGPOXDtP2FtX
         yN0g==
X-Gm-Message-State: AOJu0YyF6UipbnHId5nkqZT5eWHW8flw14c1YAst8afHzmHSSh7gjqnm
	OiCCkdzetrKQ+5+eCYomG3baREsH1hsi3OInNhzZJO5JUmoW10CrrxfmTjsNb2Uo5xHpoh0t3gj
	IJQVy4c79RearGtv5XWf4oA==
X-Google-Smtp-Source: AGHT+IEoSfdY0P3iXQY3FCb+tHcmigvpocatUt6YkOF7zXtHSG/5g+bu26HCdo+YrjUqY1sE2DfDGCXrnlid7WmZ
X-Received: from wmrc15.prod.google.com ([2002:a05:600c:acf:b0:476:ddb0:2391])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f85:b0:477:9c73:267f with SMTP id 5b1f17b1804b1-477c01ff629mr365899995e9.33.1764668208923;
 Tue, 02 Dec 2025 01:36:48 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:11 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-19-vdonnefort@google.com>
Subject: [PATCH v9 18/30] tracing: Check for undefined symbols in simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The simple_ring_buffer implementation must remain simple enough to be
used by the pKVM hypervisor. Prevent the object build if unresolved
symbols are found.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53534447e70b..38523ea2e19b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -114,4 +114,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
 obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
 obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 
+#
+# simple_ring_buffer is used by the pKVM hypervisor which does not have access
+# to all kernel symbols. Fail the build if forbidden symbols are found.
+#
+UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
+UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
+
+quiet_cmd_check_undefined = NM      $<
+      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+
+$(obj)/%.o.checked: $(obj)/%.o FORCE
+	$(call if_changed,check_undefined)
+
+always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked
+
 libftrace-y := ftrace.o
-- 
2.52.0.107.ga0afd4fd5b-goog

