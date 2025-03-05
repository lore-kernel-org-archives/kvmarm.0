Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A777192598
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192742; cv=none; b=DJK4lDscL3S7vO41nz4uh2EofEBveecKHStE4JqQOGY4UgG7z2Ax/O94dkU+TQPupxrbC1srFjwG8Bhlivky4VYNYMsTp6U182lcnMztjz2kdJ393jaeVAA3rYot4N7LsKNakhCXbzMwYHtLZ/kQ/YK882MY65KAWIY+7cw54q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192742; c=relaxed/simple;
	bh=PtWP2jycKoxlC6S/rRqog5qAdhLnRXvvHHy07Hh1D9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=A1lg5J2tsk2uF4Vwqb5E14dLeKyk07WKjaL7XWEHlwcBe7CXEqursFzJJeM08ZLPDJMAsq2ZQhQ3KwG0Le41VRAcNoEDM0E/LvMqbfYqN7SSBiAiMLs+0wXcRRAFQmbdl7B/jJE5jZISklgMz7NHXJ+Dhy8PhO47X1vuN8c1lOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVu7SOwT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVu7SOwT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IX/RrldB2VoEvfDNUYV1sErfr681DEBoI8oaCo4ZqN4=;
	b=IVu7SOwT2YL8YX0USF9DDC6uor+XstikzXAUm37xWNiqotQi4Lx4XFBmoTRthrJcCPrY8V
	ux98Xe19N2cFcwYKVFs+IP5hilsvHEdPsNRIyvJXGigoM74WSFw5GV4BjjNGxH9THbB/+y
	2UAvUMOawVZYd99LyDoB/wNT5pU1lw0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-hBTxPL1JMKWd7szDjVh2DA-1; Wed,
 05 Mar 2025 11:38:45 -0500
X-MC-Unique: hBTxPL1JMKWd7szDjVh2DA-1
X-Mimecast-MFC-AGG-ID: hBTxPL1JMKWd7szDjVh2DA_1741192723
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E36618001D0;
	Wed,  5 Mar 2025 16:38:42 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.9])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9CBB01955DDE;
	Wed,  5 Mar 2025 16:38:25 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 00/14] arm: rework id register storage
Date: Wed,  5 Mar 2025 17:38:05 +0100
Message-ID: <20250305163819.2477553-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

[Oh, it's been about a month since I posted the last version of this :/
 Unfortunately, life happened. I still do plan to post a rebase of the
 cpu model patches on top of this.]

Original cover letter below.

Changed from v1:
- Noticed that we missed the hvf code. Converted, compiled, but not tested
  as I'm lacking an environment for testing.
- Hopefully incorporated most of the suggested changes -- if I missed
  something, it was unintentional unless mentioned below.
  - fixed repeated inclusion of definitions
  - hopefully made macros more robust
  - removed distinction between reading 32/64 values, which was mostly
    adding churn for little value
  - postponed generating property definitions to the cpu model patches,
    where they are actually used
  - juggled hunks and moved them to the right patches
  - fixed some typos
- rebased to a more recent code base

NOT changed from v1:
- definitions are still generated from the Linux sysregs file
  - I still think updating the generated files on demand (so that we can
    double check the result) is the right thing to do
  - I'm open to changing the source of the definitions from the sysregs
    file to the JSON definitions published by Arm; however, I first wanted
    to get the code using it right -- we can switch out the code generating
    the file to use a different source easily later on, and I'd also like
    to steal parts of the script from Linux once integrated (which I think
    hasn't happened yet?)

Also available at
https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v2

<v1 cover letter>

[Note: I've kept the cc list from the last round of cpu model patches;
so if you're confused as to why you're cc:ed here, take it as a
heads-up that a new cpu model series will come along soon]

This patch series contains patches extracted from the larger cpu model
series (RFC v2 last posted at
https://lore.kernel.org/qemu-devel/20241206112213.88394-1-cohuck@redhat.com/)
and aims at providing a base upon which we can continue with building
support for cpu models, but which is hopefully already an improvement
on its own.

Main changes from the patches in that series include:
- post-pone the changes to handle KVM writable ID registers for cpu models
  (I have a series including that on top of this one)
- change how we store the list of ID registers, and access them
  basically, use an enum for indexing, and an enum doing encodings in a
  pattern similar to cpregs
- move some hunks to different patches
- update the scripts to generate the register descriptions, and run
  them against a recent Linux sysregs file

What I've kept:
- generating the register descriptions from the Linux sysregs file
  I think that file is still our best bet to generate the descriptions
  easily, and updating the definitions is a manual step that can be checked
  for unintended changes
- most of the hard work that Eric had been doing; all new bugs in there
  are my own :)

</v1 cover letter>

Cornelia Huck (2):
  arm/kvm: add accessors for storing host features into idregs
  arm/cpu: Add generated files

Eric Auger (12):
  arm/cpu: Add sysreg definitions in cpu-sysregs.h
  arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
  arm/cpu: Store aa64isar1/2 into the idregs array
  arm/cpu: Store aa64pfr0/1 into the idregs array
  arm/cpu: Store aa64mmfr0-3 into the idregs array
  arm/cpu: Store aa64dfr0/1 into the idregs array
  arm/cpu: Store aa64smfr0 into the idregs array
  arm/cpu: Store id_isar0-7 into the idregs array
  arm/cpu: Store id_pfr0/1/2 into the idregs array
  arm/cpu: Store id_dfr0/1 into the idregs array
  arm/cpu: Store id_mmfr0-5 into the idregs array
  arm/cpu: Add sysreg generation scripts

 hw/intc/armv7m_nvic.c                 |  27 +-
 scripts/gen-cpu-sysregs-header.awk    |  70 ++++
 scripts/update-aarch64-sysreg-code.sh |  35 ++
 target/arm/cpu-features.h             | 317 +++++++++---------
 target/arm/cpu-sysregs.h              |  22 ++
 target/arm/cpu-sysregs.h.inc          | 167 ++++++++++
 target/arm/cpu.c                      | 111 +++----
 target/arm/cpu.h                      |  80 +++--
 target/arm/cpu64.c                    | 131 ++++----
 target/arm/helper.c                   |  68 ++--
 target/arm/hvf/hvf.c                  |  36 +-
 target/arm/internals.h                |   6 +-
 target/arm/kvm.c                      | 119 +++----
 target/arm/ptw.c                      |   6 +-
 target/arm/tcg/cpu-v7m.c              | 174 +++++-----
 target/arm/tcg/cpu32.c                | 320 +++++++++---------
 target/arm/tcg/cpu64.c                | 460 +++++++++++++-------------
 17 files changed, 1230 insertions(+), 919 deletions(-)
 create mode 100755 scripts/gen-cpu-sysregs-header.awk
 create mode 100755 scripts/update-aarch64-sysreg-code.sh
 create mode 100644 target/arm/cpu-sysregs.h
 create mode 100644 target/arm/cpu-sysregs.h.inc

-- 
2.48.1

