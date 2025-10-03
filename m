Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F751C84DC
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759473579; cv=none; b=HKRBcg7ynRLLFeqab9cVTZqopmMWMju3zDZEJangtpbCCV5Xrv4GUCedMNC8mVFRs9M2b2NRhiOBnF3+DfCWdYMiEaZ5g4bqeyWZEkaBGUvw/rzq0RqYE2dvOyaltCiwLXQGjGSkQwVT6zqCPFQwVa45D+sDT6MHL48CEABQwvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759473579; c=relaxed/simple;
	bh=LX/Y9FMJvTjkJ9jsE2wR6/osViFePVkZkwtJLD4RsZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0liQArpGcjymqa+9P8aWKq+B4h9GHHKYQqEC0EA3OmVL644fDFNGqCKc4hs7pctzi9b4xrAfOdY9KEJFPi082vPa6TsGIzdMmnAevwKadXqiZ2AzgYBRnuDJG7IQv0qaPJjCgJjy5cfzkP47JD+yqD6aXTfAYntwAxrQFnH3Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x7msCqSA; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x7msCqSA"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27d67abd215so147295ad.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Oct 2025 23:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759473577; x=1760078377; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NUJR+0x4Extu7PhnW8nn0TsoPMkUfDkUjklFIsZ2dE=;
        b=x7msCqSAlCAiJq6F55YZt3m10R1GcsdiVr8eXzJISsgfxq+osu6trGjwFmMnFBczVV
         cIaW2hoUd7WzyrRdsW29EDI17xSe96xcG2y0Q6xelIVqGS9+EJ01ZoSEqVScHNOaxsuk
         blp3kE7Oop64o2+eu13yB4s7q0zEOApmp4yxFCM3wVSTeqcL1KbExj6B9ht437VE2juO
         nA7TOD4dUIYqB9l1eGwKr7VxYyDvWHm/6BpqB2VYB/icb2ayhMJD+Re9X5jRt35OgcLC
         2TfPz6j899QfO2OrLcsIlgYEApgnYfLPtgq0SevyWmprhttzPwNjGifRThIrKrw12eHq
         x5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759473577; x=1760078377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NUJR+0x4Extu7PhnW8nn0TsoPMkUfDkUjklFIsZ2dE=;
        b=O6kV+HwiwG/scG74AL17c4f5BKbNnorkkta8kg1x3TGPsd8oLvR8seDSk0tdkpCoFw
         xrUTfINKbNW86dbh1sVicObTBUvS0DTKG919J78n5I1uY4Fq8lSvoZpdIclHLZB4cB9+
         MIr19tBFWbJcu+Znp49t0d/6AuzlUS8ghK4lxkl9FABhMxkTcZoJD+EJIku6TCvxIo+L
         6KxHvXbMV13ZSVViTpF23JBdsGyAzB/uDb3eqk1E5kCfKZogY6A0c/bzFO0Rr3leJg5J
         JMqRE6XM284GSee2cgwRUh4TvW+UqOyA3drO9BhiDib3y7VJzEythLFZ+khLwxGoHjx0
         sq6w==
X-Forwarded-Encrypted: i=1; AJvYcCWsufyQKRZYwFghRa7lDy7aX4zRS9LpWtrf8N7eC2s8OD16/sCg+c1L8Of+M/+B/fqSXlzDm6Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKtgXN9PmJiAaE5SGAFfCanC2F1I+cQY86E6PO52zrCbojcgQL
	8cL1yteJHgTz8pLMUZT9NEXpZLGyND9Es1y8tjfRrQYxE1HgqwRZWGhJ7YEtGQWeUA==
X-Gm-Gg: ASbGnctCaOqNudS29BSU6xFYYaVNpT9JTy9ub47JoDNX0OEIsqT1Qt1sTu/x26zKIhN
	DB8B88TtGtmPV3Q9vYyOif07qsTAy1LeBoQl+f8/uRxk/A3zNSEXT2CwdGzCzuJy6hhqvKhVgGD
	Y6MC6/ZnnOdkajuasC7jMKx428voc7BiBb9Mpa+mZxjSg8AUGh04pCHJtPhoKadOV0EhtXn1LUs
	Kkc7CTzdMDw8sP2AUHsAj8ayr+Q0qLnaNsYuYJUoEzo2OQ4qRddIt5DBX0gaRoDsXStIQv1QR9h
	DQpM5yhG+0p1ZH5GXr6jz0sYGiLaywmRAOKrifg668dZeTHIfH5rfk7vfCElr3IVpE7Nyf66aEm
	rXjZQHK/HGXprq+6xe0dW7kmak978948xyfPBSxdbduV8zkH+hTrBjqkGZ5tibNIZn0VB/eG8bh
	PtNNQM/cbkgco+Zg==
X-Google-Smtp-Source: AGHT+IF225ruxuMkKqMzIY2DU6axi9BegMmyzKVEb8CRf18y/aWsRDvWSU7iRPoYcjDxe3FPYwAwQQ==
X-Received: by 2002:a17:903:3c2e:b0:268:cc5:5e44 with SMTP id d9443c01a7336-28e9a558cd2mr2630335ad.6.1759473576553;
        Thu, 02 Oct 2025 23:39:36 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1ba024sm39044885ad.68.2025.10.02.23.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 23:39:35 -0700 (PDT)
Date: Thu, 2 Oct 2025 23:39:31 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, seanjc@google.com,
	pbonzini@redhat.com, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org,
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn,
	chenhuacai@kernel.org, oliver.upton@linux.dev,
	ajones@ventanamicro.com
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
Message-ID: <20251003063931.GA1130776.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-10-vipinsh@google.com>
 <86qzvnypsp.wl-maz@kernel.org>
 <20251001173225.GA420255.vipinsh@google.com>
 <86a529z7qh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a529z7qh.wl-maz@kernel.org>

On 2025-10-02 15:41:26, Marc Zyngier wrote:
> On Wed, 01 Oct 2025 18:32:25 +0100,
> Vipin Sharma <vipinsh@google.com> wrote:
> > 
> > On 2025-10-01 09:44:22, Marc Zyngier wrote:
> > 
> > > > +in `default.test` files. Each KVM selftest will have a directory in  which
> > > > +`default.test` file will be created with executable path relative to KVM
> > > > +selftest root directory i.e. `/tools/testing/selftests/kvm`.
> > > 
> > > Shouldn't this honor the existing build output directives? If it
> > > actually does, then you want to call this out.
> > > 
> > 
> > To generate default test files in a specific directory one can use
> > "OUTPUT" in the make command
> 
> The standard way to do this is documented in the top level Makefile:
> 
> <quote>
> # This does not need to match to the root of the kernel source tree.
> #
> # For example, you can do this:
> #
> #  cd /dir/to/store/output/files; make -f /dir/to/kernel/source/Makefile
> #
> # If you want to save output files in a different location, there are
> # two syntaxes to specify it.
> #
> # 1) O=
> # Use "make O=dir/to/store/output/files/"
> #
> # 2) Set KBUILD_OUTPUT
> # Set the environment variable KBUILD_OUTPUT to point to the output directory.
> # export KBUILD_OUTPUT=dir/to/store/output/files/; make
> #
> # The O= assignment takes precedence over the KBUILD_OUTPUT environment
> # variable.
> </quote>
> 
> Your new infrastructure should support the existing mechanism (and
> avoid introducing a new one).
> 

Options "O" and "KBUILD_OUTPUT" are not supported by KVM makefile. I
tried running below commands in KVM selftest directory

  make O=~/some/dir
  make KBUILD_OUTPUT=~/some/dir

Both of the command generate output in the KVM selftest directory. So,
my new Makefile rule "tests_install" is behaving as per the current KVM
behavior.

However, building through kselftest Makefile do support "O" and
"KBUILD_OUTPUT". For example, if we are in kernel root directory,

  make O=~/some/dir -C tools/testing/selftests TARGETS=kvm

now output binaries will be generated in ~/some/dir. To make testcases
also be generated in the output directory below change is needed. 

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6bb63f88c0e6..a2b5c064d3a3 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../build/Build.include
 
-all:
+all: tests_install
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
@@ -358,4 +358,7 @@ tests_install:
        $(foreach tc, $(list_progs), \
                $(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
 
+       @if [ ! -d $(OUTPUT)/runner ]; then             \
+               cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
+       fi
        @:

Since testcases by themselves will not be useful, I have updated the
rule in the above diff to copy runner code as well to the output directory.

I think this brings my changes to honor existing build output
directives. Let me know if this needs some fixes.
