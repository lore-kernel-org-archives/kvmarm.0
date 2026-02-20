Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E242765F5
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548174; cv=none; b=pGPCOiOG7D75mC5C0p4AQrxhC9phXguK1R734f/Pn+quplysh5t+eJ/+zu13SFWe//lpxuRLbxu9ipVaD3HizvmJmOeu8zzWzjXXmM/KTXDhuvK95ee6aHqsjY0FhbtKUtsnfv8dliQrqwn+M8O3KUNkKpVbPt4TAxRuHpKNyVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548174; c=relaxed/simple;
	bh=JTfAAOI5NFSnyVDX0VArNQcIEUpjnwvy4yTPQS3Whcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+55HxoELw+y0rzXIT7Ztc2UX6ljyLoA3DbusmY3FYbVFS0ks8CjKNA0Zjuw7Ciyv5gsJGp7kFKbrUHZGQd3c5ffXCmRaaylTWGiztE0wrpA5I9oB3rB1cPyaeq9SFsxD+E+LAdc8yQw/2SsFFPd57KQHIqEw1oOa8M9Isrfuzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zkq7+iBP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zkq7+iBP"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c709551ec08so7785326a12.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 16:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548170; x=1772152970; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEeICHjtMij91JM5H//TSYr8sTPe1JzhDMQCFWqYwXE=;
        b=Zkq7+iBPV1GtXK+tde3L7b3ggjHJNPgETYrEV1GcOSjDCpGSSpHQ+sVTmFLjgzu8CF
         heapx4jqpANU1zKdh/sQGMsB7RgB9zQwCYj/aDSHsyQfaaEs/XeL+ODn6ofUib/CAHNk
         Yqezl4MFAY2aqzytRvy/Bcjg8oRgtJlNllMhwUrptB7RimWU0hGdyjGVMkTHJPLZMGB/
         r78Onm53x3eJsICnwfjom2JzI/I5SNAZAme/oQu3Uon3OQLk+rTc18L2Aawtaa6htnGT
         90EPoM1GyvGwV6ZXMHRp6j70lV7mDXjxgv6M56d8K2jWBxKxjILbLW7VGOyZj6zmSjeG
         v7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548170; x=1772152970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEeICHjtMij91JM5H//TSYr8sTPe1JzhDMQCFWqYwXE=;
        b=sDcYSLA7luhPuIC32dg5mD333yfkedOm3trl57zUdjtAqAxP3yONE88XkucosIta23
         v33fgDG2OxSaMABgCRaJRjz3EjlPhB/5MCv5HwFiySZ3SRxynkoODxkHY47vNNuHbrVd
         ch1G9OPOvNr4bQIwh9ZmFD9MJvZCTD7Y5F0XNz3VroQUGwCmqt8DeEv8GVlIibRtl8FE
         eTeA+7B4jl23eKOEpV+0Llxo2oWvExJFQFR5U47ZK7bwfM6efrVxuTFJpMdiC3bl2Hll
         3b85BKAgNnZlgb42KC5H6Ej+lvecbJYEBZhKlzv/b19zXAV+7U0Tmw5Ct/rYjrmcE6M4
         ofeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtBSyowHaPRsoqn0R1SLPGSFOyjlU9Absm9zf0kSnnbChF7ZUGkgiffe+Y4lprvNPRL+SwIeE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1zbSP4FarvApsls15w7F+gTPQtHXbdkaFYYdtEgkhc3QDoDSy
	56pnPurUkoa1eQSESkMObP28fZQ+l/OzHXfGV5zb2axkD0Tfji55MiienzSNGwuopsLE2AJnilM
	en1zGYPfIblDDUg==
X-Received: from pgja7.prod.google.com ([2002:a63:cd47:0:b0:c6e:28c3:dd4c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:493:b0:394:6208:6626 with SMTP id adf61e73a8af0-394fc2555e0mr6371053637.20.1771548169297;
 Thu, 19 Feb 2026 16:42:49 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:22 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-10-dmatlack@google.com>
Subject: [PATCH v2 09/10] KVM: selftests: Use s16 instead of int16_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Use s16 instead of int16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int16_t/s16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 8d60aa81e27e..2a3ab9c168f0 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -288,7 +288,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		else if (qualifier == 'h') {
 			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
-				num = (int16_t)num;
+				num = (s16)num;
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-- 
2.53.0.414.gf7e9f6c205-goog

