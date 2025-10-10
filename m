Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D512F9985
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760110441; cv=none; b=Rh468bX21SPm2eNlwaaoLRr/yyTXCMWDJ7cZVf31NxcvuAjwYZ1M6/B5+ydkNSm6KdqH1Be8k8hIUe9PR7sipM+bgOknjGuoIJIMuYqmsnkcOWGUl+C4YgtdkoSb3UVoY8n/e4Hlk8nCWdFKGiEZJBwvNfb4vGyhSurpIKwKaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760110441; c=relaxed/simple;
	bh=frUkYpzcUrHXA6VVFUE2ZzYeLLnhLDbl0nvpcjfOcKY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=My8pHSEZBTndXaG5i8dwYsBz/UwCRq1Qb8BHZoKktBOwgm/0ZJTeJ5hwfn2/3QL3f25rIzD81NRYP6Gw0BSS3MDkbNAFVbrrC9Pwbr5oCDVzOaJS8zPrVUBvKLe1kNf8JvNM8xIBs1PPiKwz1cvGfpb+w9IaD4YA35AFZtNY7RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ab2/y1oG; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ab2/y1oG"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d603a269cso22490797b3.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760110437; x=1760715237; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=frUkYpzcUrHXA6VVFUE2ZzYeLLnhLDbl0nvpcjfOcKY=;
        b=Ab2/y1oGjORPfR/WZuloK6id6iDV8rbsqT6zjTJf8BqfM6PtQFT4VqL9QNKA9/BZEj
         MafuD42HXwxcm3vmpXngeeDG12mXlJC489rcAC9dC5mt1ydirCZkbU2IlL3SCDyNlNPb
         mk9R7q20lt+qzkoNHJ7zgbdLy54OBp56vlmA79H8VtU18i+P9GYTtH/y1mwG0rSBzbo9
         cHR3H22kr2rBEuXt2SjtuRdENOeHuQDp/Hm01/fxZoD7MxnGppwLoeF9LE2ojLcrOsbq
         hEw+jYvC9jP/YQ9wtkGWPhdvqAKU7dZiBJlCJKhQ92BSR0jnXGEpqUDFnWc/YPrFMosq
         AWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760110437; x=1760715237;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=frUkYpzcUrHXA6VVFUE2ZzYeLLnhLDbl0nvpcjfOcKY=;
        b=H/XpnboeOGvTb6Onbj+LfaltBtqEnfYSrmEeyCeA4KI5f2/t8Uigxwv6mPzU/kVa27
         a94HzwrGSdjabdU+VUDdud+Cx9s0iAhB0qdGGAy6Kv9yFAln+aSpRA2OjD3whXLwOSTo
         Zk7JHXNdT+8czblhGU910N6sQoCDV7HjvKgJAUWN3V4hLTnL9czlGXyJjzL1sTEjRzoa
         yNPGt3XRj/KBzpzbVWjzXAa5im9GCAE5cW9RKjwjJIKgU/nv4PrBKlvz8EJxxPjjt66+
         4hpwTv1XWi+RVY9N2xYQHd49LxLuycHDZgZcPn9sQYMT1sFkgNM5jMdqv06bfd+vaZbc
         aU4Q==
X-Gm-Message-State: AOJu0Yza64DFccCr5DregN62eyn5eOq+LvDOW05ZaO5TrREEnLAoJRtL
	JVXfgNBcsLPnevd3UKylAJfsbZlnzeNHtDpgbWQLsKFHEo/nlu8mqFj0xGHOS5QLvnTHSuhhGx/
	/VSl+DEFJf4/Y+VSoyij90r9fuZZ7uIL2KhgUTiKExFlv+L6I93Ux
X-Gm-Gg: ASbGncvHjoOiy/m79nrpTC3grSE4hNndKSD57imhS+PQPqumR85hIeQhlRlAiMX3kKs
	uBj9uL5+nGqvjGu/aUaLOOaaJes3I5rvBgxTq/HjuWT6BVoeSeFTE2Rj4nviolkGqBnP0EEAbVW
	RuIZzQmnQmIBRnhozuQuuAXaQOJH6Xm+QP5ttewu8d3RsuVqF4rJ3ZgLc4FORBAr1GSvTIAMAMH
	rrizRVrvtsnIZQWf45+5aGJlkdPFv1+cHHGxyV4Ig==
X-Google-Smtp-Source: AGHT+IGXQ1qHRPjaHHpeCld1hjx723piat0vYL7kxBAa78fV5yV5CB2g1rdceNDsSmts7Wn3+w+vffhbfITY7B7esDg=
X-Received: by 2002:a05:690e:10d:b0:635:4ece:20ad with SMTP id
 956f58d0204a3-63ccb9325dbmr8348969d50.50.1760110436654; Fri, 10 Oct 2025
 08:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 10 Oct 2025 16:33:45 +0100
X-Gm-Features: AS18NWCy8McSdx9_JL_LhBOWDQKGxePj-5XJXb6naQ834XykmkXm9J_6uNSFgkk
Message-ID: <CAFEAcA8TpQduexT=8rdRYC=yxm_073COjzgWJAvc26_T+-F5vA@mail.gmail.com>
Subject: Saving and restoring state of a KVM VM using GICv2 fails
To: "open list:ARM" <kvmarm@lists.linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

I was testing doing saving and restoring state of a KVM VM that
happened to be using GICv2, and I discovered that it doesn't
seem to work. Running the VM works fine, as does the state save,
but when you try to reload the state it fails:

$ /work/test-images/virtv8/runme ./build/arm/qemu-system-aarch64
-enable-kvm -machine gic-version=2 -loadvm gic2
qemu-system-aarch64: Could not set register op0:3 op1:0 crn:0 crm:1
op2:1 to 11011 (is 10011011)
qemu-system-aarch64: error while loading state for instance 0x0 of
device 'cpu': post load hook failed for: cpu, version_id: 22,
minimum_version: 22, ret: -1

This is QEMU saying that it tried to do the KVM_SET_ONE_REG for
ID_PFR1_EL1 to 0x11011, and failed, and that KVM thinks that register's
value is 0x10011011. The difference is that KVM has the GIC field set
(bits [31:28]).

Looking at the kernel code, I think this happens because the kernel
only clears out the GIC field of the idreg in kvm_finalize_sys_regs(),
which gets called when the vcpu is first run. So because state save
happens after the vcpu has run for a bit, it sees the value of the
register with the GIC field set to 0, and that's what it writes out
into the saved state data. But the loadvm operation happens
with a fresh new VM which has never been run. So the kernel still
thinks the GIC field in the idreg should be 1, and it fails the
SET_ONE_REG operation which tries to write it to 0.

This kernel reports itself as
 6.14.0-1012-aws #12~24.04.1-Ubuntu SMP Fri Aug 15 00:07:14 UTC 2025

The failure happens for both aarch32 and aarch64 guests.
I haven't tested whether it happens on a host that has only
64-bit EL1 (i.e. where ID_PFR1_EL1 doesn't exist). It may be
that there's some flexibility about writes to ID_AA64PFR0_EL1.GIC
which needs to also be permitted for ID_PFR1_EL1.GIC.

thanks
-- PMM
