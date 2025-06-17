Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77912ECD1B
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174793; cv=none; b=CVspRonIdLGBH+rzpVWxq5OGG7CFC1sn0NIQ1pgAHors99z0pqZEPWW1wN+zXsjbve1schjUxGgClFZlzMvTk5FM8SA2F0s6+BoKBsQatQxqIOOGt3K0kLdOwATcDkHQ+ymBakfrtlbR3toPFYtkXwvMhHciDliYfK56O6STnCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174793; c=relaxed/simple;
	bh=o/adySMHtGF0eRApQ/jYpl0Av3pTshS2kTk9vuQA7IM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=BrCyMWRmJ2+YGVWu1ShQ3qMAeyrgu45UED6Ph97I1GjuTetYG46Z34REF3K6ElkDG7gJJdM49tJlOEYqNpK0+h4k4c4iD75FauV+mXfAvVeA9tQnk3JvD0c90pJqmppomjbIL7l787vdQHwyUNIBL28L5/b/6YoRmH3t5rqTZCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aWYcdGTh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWYcdGTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=snIE0Kxo+Asc1ZpCPVz5i7efIGpQ1hiprvFRa3bQLZQ=;
	b=aWYcdGThQs0AbPnAlF9Jgg2bERYKmJ9TvORtZSFenXN1Lh+sl4O8nzInVasK2oOtKLPF9p
	Ou5Z/EAV5pTPpzqgyA7V8qJ94y/ao2eO0DbjAo+6jbE4HuW9CReSNcWgq+D7zU8YOW2q2A
	/EShMqd6Z2oZ4ObydMq14VEhyb7ru3o=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-OoLk3BFyOeepgyAsjOnptA-1; Tue,
 17 Jun 2025 11:39:47 -0400
X-MC-Unique: OoLk3BFyOeepgyAsjOnptA-1
X-Mimecast-MFC-AGG-ID: OoLk3BFyOeepgyAsjOnptA_1750174785
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B67861956046;
	Tue, 17 Jun 2025 15:39:43 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EC8C180035C;
	Tue, 17 Jun 2025 15:39:36 +0000 (UTC)
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
Subject: [PATCH v8 00/14] arm: rework id register storage
Date: Tue, 17 Jun 2025 17:39:17 +0200
Message-ID: <20250617153931.1330449-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Mostly addressed Peter's feedback:
- make sure every inbetween stage compiles (also fixed some bonus issues)
- try to make the scripts more robust, add a note the generated file,
  and make sure to grab only registers we actually want
  - I did a half-hearted attempt to use python instead of awk, but I'm
    out of my depth, especially with the script that will be used for
    the register fields in the cpu models series

Also available at
https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v8

<v7 cover letter>
Some small fixes, including fixing up/adding SPDX identifiers, keeping the
series bisectable, and updating MAINTAINERS (please check if that's ok.)

<v6 cover letter>
Just some small changes:
- fixed up some botched conversions noted by Eric (thanks!)
- rebased to current master
- new patch with a small cleanup suggested by Eric

<v5 cover letter>
Just a quick respin to fix a missed conversion in hvf.c.

<v4 cover letter>
Next iteration of the id register patches; only small changes.

Changed from v3:
- added R-bs (thanks!)
- added missing SPDX header
- merged patch introducing accessors for kvm to the first user
- skip over sysregs outside of the id register range when generating
  register definitions again

Also available at
https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v4

<v3 cover letter>
Yet another update of the id register series, less changes this time
around.

Changed from v2:
- changed generation of the various register defines via the "DEF"
  magic suggested by Richard
- some kvm-only code moved to kvm.c; some code potentially useful to
  non-kvm code stayed out of there (the cpu model code will make use
  of it, and that one should be extendable outside of kvm -- a
  revised version of those patches is still in the works, but I'll be
  off for a few days and rather wanted to get this one out first)

Also available at
https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v3

<v2 cover letter>

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
</v2 cover letter>
</v3 cover letter>
</v4 cover letter>
</v5 cover letter>
</v6 cover letter>
</v7 cover letter>

Cornelia Huck (2):
  arm/cpu: switch to a generated cpu-sysregs.h.inc
  arm/kvm: use fd instead of fdarray[2]

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

 MAINTAINERS                            |   1 +
 hw/intc/armv7m_nvic.c                  |  27 +-
 scripts/arm-gen-cpu-sysregs-header.awk |  37 ++
 scripts/update-aarch64-sysreg-code.sh  |  32 ++
 target/arm/cpu-features.h              | 317 ++++++++---------
 target/arm/cpu-sysregs.h               |  42 +++
 target/arm/cpu-sysregs.h.inc           |  53 +++
 target/arm/cpu.c                       | 111 +++---
 target/arm/cpu.h                       |  80 +++--
 target/arm/cpu64.c                     | 128 ++++---
 target/arm/helper.c                    |  68 ++--
 target/arm/hvf/hvf.c                   |  39 ++-
 target/arm/internals.h                 |   6 +-
 target/arm/kvm.c                       | 139 ++++----
 target/arm/ptw.c                       |   6 +-
 target/arm/tcg/cpu-v7m.c               | 174 +++++-----
 target/arm/tcg/cpu32.c                 | 320 ++++++++---------
 target/arm/tcg/cpu64.c                 | 459 +++++++++++++------------
 18 files changed, 1114 insertions(+), 925 deletions(-)
 create mode 100755 scripts/arm-gen-cpu-sysregs-header.awk
 create mode 100755 scripts/update-aarch64-sysreg-code.sh
 create mode 100644 target/arm/cpu-sysregs.h
 create mode 100644 target/arm/cpu-sysregs.h.inc

-- 
2.49.0

