Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF1DC49EAB
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 04:48:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 153E8613A9
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 04:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 153E8613A9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1FF4B0AD;
	Fri, 18 Jun 2021 00:48:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fRIZ99Xum2My; Fri, 18 Jun 2021 00:48:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FBA4B09B;
	Fri, 18 Jun 2021 00:48:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 868DA4B08C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 00:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVwkHjdaLKQ0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 00:48:32 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 268764B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 00:48:32 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 17-20020a630b110000b029022064e7cdcfso2809860pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 21:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ACDlgMuXCZDsetX7KRhrcOX3+jjuxXZRreYDTT75YTU=;
 b=JCC/DbH8et+zeP3tBTw3UT+39oOBrX/FGV9hMQ2NwQkQNp1Uur1QpgQfJ8QnvjuJEz
 XCSk32Gua/LrNCyC01iwzIygcv1uUSWLJStfqCtBcgrxj78PosE3yB2K1P09lRTAcPiC
 kPZb+ar3PsVVvQQonl5zP/IIFpM1Pes+3CKHK/0poH7MOZSENcd+43zX3m7JF/LuylXK
 XVyp3av2emtCJpsjrV22r/1QGgInxeNpmvDiP9CQyRVeLYosnOUjUStt7LzqEDroRQHD
 fGpXFDW1QIW2ThjvzoMerJinwtYfLgQgQxbyOTz56g9g9EkmE38016p15WuEvJq3Qkgf
 j4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ACDlgMuXCZDsetX7KRhrcOX3+jjuxXZRreYDTT75YTU=;
 b=KJsMhvyTspjIXPc+iPK3y3T3fwngTzyqwSV3XKtRodvYsu8sadGPWneStYv3QRuU8f
 3u2+0mtYo2CKe/4SYD7mHgVq/uR7sBTCETwdqKYskdDqpImnvDZjI9EB2u0FQhduztE/
 XVZFC08cqB25xFNuYNqFGVfZy35erTmXHSCoUGLQXVEoUUsfKWfh0GDJjIJ/yKfzmeCu
 Q0sdVPinry2svoU+oWI9fLSRpCsVJj9YzagkwBU3NWBc/knBdAYnQhuLpa8WVe/bx7/c
 d3uBpHhJ0s1oVMGORH25FsbeQgLcmeZ96YtK4wFbjcZKOfpjpUOUvsGGMl5OhO2L71F5
 VOiQ==
X-Gm-Message-State: AOAM532ilr997aJZYhsIGomSzMX0FnFIy3hZFeFB66um1R51FAYIgko1
 SlF10nvB0eSKd8WJC9XpgqQ8GE5OJHq7DffLow==
X-Google-Smtp-Source: ABdhPJxjP7eUjIDRktqIzAkQNpt7aF6od26SEO+/ze1THLepoxd/AqNiFwUQ5wP1PcwM1RyWisRVUZGmqDu+Lc1EnA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a62:6490:0:b029:2f7:2fba:4d79 with
 SMTP id y138-20020a6264900000b02902f72fba4d79mr3204154pfb.29.1623991711344;
 Thu, 17 Jun 2021 21:48:31 -0700 (PDT)
Date: Fri, 18 Jun 2021 04:48:17 +0000
In-Reply-To: <20210618044819.3690166-1-jingzhangos@google.com>
Message-Id: <20210618044819.3690166-6-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH v11 5/7] KVM: stats: Add documentation for binary statistics
 interface
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>, 
 LinuxS390 <linux-s390@vger.kernel.org>, 
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>, 
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>, 
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>, 
 Greg KH <gregkh@linuxfoundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This new API provides a file descriptor for every VM and VCPU to read
KVM statistics data in binary format.
It is meant to provide a lightweight, flexible, scalable and efficient
lock-free solution for user space telemetry applications to pull the
statistics data periodically for large scale systems. The pulling
frequency could be as high as a few times per second.
The statistics descriptors are defined by KVM in kernel and can be
by userspace to discover VM/VCPU statistics during the one-time setup
stage.
The statistics data itself could be read out by userspace telemetry
periodically without any extra parsing or setup effort.
There are a few existed interface protocols and definitions, but no
one can fulfil all the requirements this interface implemented as
below:
1. During high frequency periodic stats reading, there should be no
   extra efforts except the stats data read itself.
2. Support stats annotation, like type (cumulative, instantaneous,
   peak, histogram, etc) and unit (counter, time, size, cycles, etc).
3. The stats data reading should be free of lock/synchronization. We
   don't care about the consistency between all the stats data. All
   stats data can not be read out at exactly the same time. We really
   care about the change or trend of the stats data. The lock-free
   solution is not just for efficiency and scalability, also for the
   stats data accuracy and usability. For example, in the situation
   that all the stats data readings are protected by a global lock,
   if one VCPU died somehow with that lock held, then all stats data
   reading would be blocked, then we have no way from stats data that
   which VCPU has died.
4. The stats data reading workload can be handed over to other
   unprivileged process.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 176 ++++++++++++++++++++++++++++++++-
 1 file changed, 175 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e328caa35d6c..7ca1c8d190c0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5034,7 +5034,6 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
-
 4.131 KVM_GET_SREGS2
 ------------------
 
@@ -5081,6 +5080,173 @@ Writes special registers into the vcpu.
 See KVM_GET_SREGS2 for the data structures.
 This ioctl (when supported) replaces the KVM_SET_SREGS.
 
+4.133 KVM_GET_STATS_FD
+----------------------
+
+:Capability: KVM_CAP_STATS_BINARY_FD
+:Architectures: all
+:Type: vm ioctl, vcpu ioctl
+:Parameters: none
+:Returns: statistics file descriptor on success, < 0 on error
+
+Errors:
+
+  ======     ======================================================
+  ENOMEM     if the fd could not be created due to lack of memory
+  EMFILE     if the number of opened files exceeds the limit
+  ======     ======================================================
+
+The file descriptor can be used to read VM/vCPU statistics data in binary
+format. The file data is organized into three blocks as below:
++-------------+
+|   Header    |
++-------------+
+| Descriptors |
++-------------+
+| Stats Data  |
++-------------+
+
+The Header block is always at the start of the file. It is only needed to be
+read one time for the lifetime of the file descriptor.
+It is in the form of ``struct kvm_stats_header`` as below::
+
+	#define KVM_STATS_ID_MAXLEN		64
+
+	struct kvm_stats_header {
+		__u32 name_size;
+		__u32 count;
+		__u32 desc_offset;
+		__u32 data_offset;
+		char id[];
+	};
+
+The ``id`` field is a '\0' terminated string which identifies the corresponding
+KVM statistics. For VM statistics, it is in the form of "kvm-{kvm pid}", like
+"kvm-12345". For VCPU statistics, it is in the form of
+"kvm-{kvm pid}/vcpu-{vcpu id}", like "kvm-12345/vcpu-12".
+
+The ``name_size`` field is the size (in byte) of the statistics name string
+(including trailing '\0') appended to the end of every statistics descriptor.
+
+The ``count`` field is the number of statistics.
+
+The ``desc_offset`` field is the offset of the Descriptors block from the start
+of the file indicated by the file descriptor.
+
+The ``data_offset`` field is the offset of the Stats Data block from the start
+of the file indicated by the file descriptor.
+
+The Descriptors block is only needed to be read once for the lifetime of the
+file descriptor. It is an array of ``struct kvm_stats_desc`` as shown in
+below code block::
+
+	#define KVM_STATS_TYPE_SHIFT		0
+	#define KVM_STATS_TYPE_MASK		(0xF << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_INSTANT
+
+	#define KVM_STATS_UNIT_SHIFT		4
+	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_NONE		(0x0 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+
+	#define KVM_STATS_BASE_SHIFT		8
+	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
+
+	struct kvm_stats_desc {
+		__u32 flags;
+		__s16 exponent;
+		__u16 size;
+		__u32 offset;
+		__u32 unused;
+		char name[];
+	};
+
+The ``flags`` field contains the type and unit of the statistics data described
+by this descriptor. Its endianness is CPU native.
+The following flags are supported:
+
+Bits 0-3 of ``flags`` encode the type:
+  * ``KVM_STATS_TYPE_CUMULATIVE``
+    The statistics data is cumulative. The value of data can only be increased.
+    Most of the counters used in KVM are of this type.
+    The corresponding ``count`` field for this type is always 1.
+  * ``KVM_STATS_TYPE_INSTANT``
+    The statistics data is instantaneous. Its value can be increased or
+    decreased. This type is usually used as a measurement of some resources,
+    like the number of dirty pages, the number of large pages, etc.
+    The corresponding ``count`` field for this type is always 1.
+
+Bits 4-7 of ``flags`` encode the unit:
+  * ``KVM_STATS_UNIT_NONE``
+    There is no unit for the value of statistics data. This usually means that
+    the value is a simple counter of an event.
+  * ``KVM_STATS_UNIT_BYTES``
+    It indicates that the statistics data is used to measure memory size, in the
+    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
+    determined by the ``exponent`` field in the descriptor. The
+    ``KVM_STATS_BASE_POW2`` flag is valid in this case. The unit of the data is
+    determined by ``pow(2, exponent)``. For example, if value is 10,
+    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
+    can get the statistics data in the unit of Byte by
+    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
+    10 * 1024 * 1024 Bytes.
+  * ``KVM_STATS_UNIT_SECONDS``
+    It indicates that the statistics data is used to measure time/latency, in
+    the unit of nanosecond, microsecond, millisecond and second. The unit of the
+    data is determined by the ``exponent`` field in the descriptor. The
+    ``KVM_STATS_BASE_POW10`` flag is valid in this case. The unit of the data
+    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
+    ``exponent`` is -6, which means the unit of statistics data is microsecond,
+    we can get the statistics data in the unit of second by
+    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
+  * ``KVM_STATS_UNIT_CYCLES``
+    It indicates that the statistics data is used to measure CPU clock cycles.
+    The ``KVM_STATS_BASE_POW10`` flag is valid in this case. For example, if
+    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
+    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
+
+Bits 8-11 of ``flags`` encode the base:
+  * ``KVM_STATS_BASE_POW10``
+    The scale is based on power of 10. It is used for measurement of time and
+    CPU clock cycles.
+  * ``KVM_STATS_BASE_POW2``
+    The scale is based on power of 2. It is used for measurement of memory size.
+
+The ``exponent`` field is the scale of corresponding statistics data. For
+example, if the unit is ``KVM_STATS_UNIT_BYTES``, the base is
+``KVM_STATS_BASE_POW2``, the ``exponent`` is 10, then we know that the real
+unit of the statistics data is KBytes a.k.a pow(2, 10) = 1024 bytes.
+If the unit is ``KVM_STATS_UNIT_SECONDS``, the base is ``KVM_STATS_BASE_POW10``,
+the ``exponent`` is -6, then we know that the real unit of the statistics data
+is microsecond a.k.a 1 second * pow(10, -6) = 1 microsecond.
+
+The ``size`` field is the number of values of this statistics data. Its
+value is usually 1 for most of simple statistics. 1 means it contains an
+unsigned 64bit data.
+
+The ``offset`` field is the offset from the start of Data Block to the start of
+the corresponding statistics data.
+
+The ``unused`` fields are reserved for future support for other types of
+statistics data, like log/linear histogram. Its current value is always 0.
+
+The ``name`` field is the name string of the statistics data. The name string
+starts at the end of ``struct kvm_stats_desc``.
+The maximum length (including trailing '\0') is indicated by ``name_size``
+in ``struct kvm_stats_header``.
+
+The Stats Data block contains an array of statistics data whose type is __u64.
+It would be read out by userspace periodically.
+The order of data value in Stats Data block is the same as the order of
+descriptors in Descriptors block.
 
 5. The kvm_run structure
 ========================
@@ -6969,3 +7135,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_STATS_BINARY_FD
+----------------------------
+
+:Architectures: all
+
+This capability indicates the feature that userspace can create get a file
+descriptor for every VM and VCPU to read statistics data in binary format.
-- 
2.32.0.288.g62a8d224e6-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
