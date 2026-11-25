Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587372;
	b=ln41i/llQWFy0XSMbwW7J4Xw5/SR+IZqZuvUMIMQ9+3KMy9nZvNpwXrbgOl4oVbrVLmZ
	 vAtThC59ouRz9HJhH7UJU37MbQNJlqI4atGR40QjA5f3DReFmZ4EjfKmkcbCKtAS1vK/U
	 KcuPB2q/Tk/kTCB6FOSdSfv0QHx1qInlN7T4Z+NYkM6nhHobC73KKpcrYacsVPCNxJwjR
	 O8Ycuj1d2SHBoCYusocVrI/ZemvEvHgIsFxGUPfWtXZVKQZR7FcTk76GIRKmq01f1oCYq
	 BuwleM2ef0lGx8uMCO2YRq0VTes0CYWAH9OlaTsxxV4p38g5smBckOgsGtXeeRICpDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587372;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
	b=Y2YC7yLM09EMxAoAxJt9mC7NL7CY2j12msOXthk981xcZ8gmsD/jVk7KyakSw5l4C3N/
	 jxtUR1PcanxszLYsvXCpsXK+AmHQwJ32EDsXFJq9iGwnUpgD7sR+NqY9lUChneusJYG/c
	 99VUTQv6GDIYLjTub2MK6m1i8zANM+JOg02BG+SrHy5HuIQZd1A6xOxazxfwhq3Xca5Wy
	 NbwvP2TxqLeSCVm3KjsEQhP2ifTvHAs8wNmWkdKAELpzhsxDj4mZZvnkFj3TbvA0X/oDq
	 xOQqPe08H/SoqpFvIfV1HBiow9+IDLdpaoegYOVBSSS2uTuTZVutbdaQwtyYxqbDIeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JvLlLdS3;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57060A261B
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF57060A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JvLlLdS3
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-386b8624cf7so555045eec.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587371; x=1796192171; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
        b=JvLlLdS3Ac20Sy2sXtYgeEV1iNR4v7orkb06fPxwCFI5Smp7BLDooUOvfCJjA4Hg96
         U/qqDqHdonBtpoJ9d0SM6nSWrdTcgJdryLgILhJmXdEM0QH5NgC/urRGoG50T7UUzAKH
         Qvzij1MX/ALTtQgK+8szjQtf6undJAByra49aTpkit/NoQjnWejLbWlmF6VehYiNrDWc
         +ur5yFXVStEvB3LKamQ59MecPcSm3Q/n455FKVGvHCTTX/6if2L6GwSwE1phLY/4J6Px
         KdbYMfse6Qpr7UyQvvnG6lGXb9eqPcbPS/rJ1IgkYpS4mczQleV/m8IHaHJmketjkcJi
         selw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587371; x=1796192171;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
        b=G8cfG8Vnos8pWx01ngxxFJWHNE+TmT9ZEFOl1YSkOnocne5jm/lQTCO4nUGF1tOM9v
         ksNWJLQW8tOQotjbKFor3O8bkg6evc1yy9yGbdAtHutlE4QFFh00UYKtqL1VXVIiOZX2
         hoP72R03MQr8NBnk8EKewi1bIdzEO0Xzjddqz59n3cmRO/h2ujE8KPah/9xvjVhW2PaL
         IFErfPBZdCC+DK0tOsEkS3ZnI40w3SAY+u73IXazlXUtPKHL8j9R7mmUQ4v9bEnG+XNp
         6K8hGHz4CvinfAHRu0m+0Eyb7gxemLAtsrUq7KcbjN4qh0fBpf23/b+GozPMokNQxW2c
         YxRQ==
X-Forwarded-Encrypted: i=1; AL+hErEc5rURAe6bqBG+aO2+OqH6XUZDsipkNq4qfb3gy6qXyqaDT0zzyO4n7ZoMGejO7+haj3NAYHo=@lists.linux.dev
X-Gm-Message-State: APuU4Z+kIhkz5rfVjaxZp5NHodtDLBsa8EC5xcyUrZoSuR9fZi/rKy81
	Nml8O0xJ52wKrXfRGaqNtIoClZbU9iv5ntoqB1Uef7Jpf/uWjoSAqepelUyKw0GAq2nvPDQk1Yl
	ZOn2+t0Z2xg==
X-Received: from dybou2.prod.google.com ([2002:a05:7300:e5c2:b0:384:c70c:3c65])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:269e:b0:376:5b99:a816
 with SMTP id 5a478bee46e88-3856c2c3fb4mr17120337eec.3.1795587370674; Tue, 24
 Nov 2026 22:16:10 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:00 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-8-irogers@google.com>
Subject: [RFC PATCH v2 07/30] objtool/ibt: Ignore .eh_frame relocations during
 ENDBR validation
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

When vmlinux.o is built with -fasynchronous-unwind-tables and
CONFIG_X86_KERNEL_IBT=y, .eh_frame FDE headers contain PC-relative
relocations referencing function start addresses across .text. Because
.eh_frame is read-only unwind metadata rather than executable code or
indirect branch targets, skip .eh_frame* sections during objtool's IBT
relocation validation alongside .orc_unwind_ip and DWARF .debug_*
sections.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 931c5c412f15..e631b0da9bad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4644,6 +4644,7 @@ static int validate_ibt(struct objtool_file *file)
 		if ((!strncmp(sec->name, ".discard", 8) &&
 		     strcmp(sec->name, ".discard.ibt_endbr_noseal"))	||
 		    !strncmp(sec->name, ".debug", 6)			||
+		    !strncmp(sec->name, ".eh_frame", 9)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".kcfi_traps")			||
-- 
2.56.1.831.g720f3f5937-goog

