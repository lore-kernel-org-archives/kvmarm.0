Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8293D37F8B6;
	Fri,  4 Sep 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544587; cv=none; b=oTdgtux+G0lnKf9RIYWzO40BEJUO7iV771/2anPb/R8OLJKQvVPLp7Ev1J28WnZgi1bRnHCil8B7qudcg/nz4MMJDoxgUX/QXpWVH9dQwv2F/Px9hxyUCHAXEIUW6c/y2c13bNU7Idt6eCPaKnLUQVxCI3o3GI/3kQC37pwEv4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544587; c=relaxed/simple;
	bh=+i+qQOmlMnhgZmCjVjcybjYcoYiwWcxPC7QuojgQK1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGzcMAJHAZGdy23hNDXyojG7CVC89onUaPTVqkwvXV3X25XsOefszsnvg+HZCnx7NEMoFOhkxxE4KzA1+2/MNtAJvihlOPOK+3LGsNysS0O/UYJfvZkYIlriTfjovSNUQ563Ke2IP2bfTeiCtTxD/+T3xQ4qH0Z2cXoTf9MK11I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qUmVpX7o; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUmVpX7o"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684GhG2d3185986;
	Fri, 4 Sep 2026 17:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Tp/rQlVy5b9H8KkGE/UvNF5Djl53J
	ttIzvuDDXZXs0w=; b=qUmVpX7o/+HsMehwD8MGS0jYqhpJSz0FrQmQ6LsiGkyvc
	kSuJhPMBztlCctiWoErSwlGvaOp8nsUXMjZwT9INGW+O/T5+jhY0BQOKoVkARbdl
	KoWOd1KTudfuQqhDZpGFwPsju1au1LyB9ejEN6Ufxy/M9YR/2Pen3omT6x6ZoKFN
	NDUpB+f/PhDgxr2wHCwzdIz7ac36Klnr+0P65Bk7bBKC4nPlkqM9ogbP/XGHH7so
	dVSJhomTHMceY7D6YOAll53Ecepm8QJ3TKxQzfRgl7MGsFPvNg1MBdWOHGOmUu+2
	zz95oQTvikiACKg9FRL2K1KqhwECc9azZIaGLt/8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72k5qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684HoYTI016095;
	Fri, 4 Sep 2026 17:55:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvv3675-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:53 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 684HrwmF032217;
	Fri, 4 Sep 2026 17:55:52 GMT
Received: from donglzha-e6-vfio-setup.osdevelopmeniad.oraclevcn.com (donglzha-e6-vfio-setup.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4gbnvv366p-1;
	Fri, 04 Sep 2026 17:55:52 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhaotianrui@loongson.cn, maobibo@loongson.cn,
        chenhuacai@kernel.org, anup@brainfault.org, atish.patra@linux.dev,
        seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        dwmw2@infradead.org, joe.jin@oracle.com
Subject: [PATCH v2 0/4] KVM: Reset steal time accounting on vCPU pid change
Date: Fri,  4 Sep 2026 17:55:22 +0000
Message-ID: <20260904175550.430266-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609040163
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX7n+VNjWgH3mr
 JZx3pkbANN7dwqHVyLAS5IVrsoeWRPU3jdp0u/VtqMgZ8a9RZhONAFn6iMXT9PPQSA4NmJI+vZ5
 2jrRPIRMmK1pH07LKZf7sdEWovV4WORVYPMz4pSE18uSZkMZrtiH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX8u1jin8Hwbe3
 Ju0zFlBV+u6P6WOsEp9nLvWFpbDcOKWT33tE7w+ntOHeRjwxUwxIbkoq8XffFf5KdagV7vdILO6
 GxA+FyLW7GZWd4A+tOstnevoKbj7yf1W5UX3BmsYhkLUZ4obsS5WUEM9SjeKB69BdSYSvv+m/v1
 dGUAn5rV8IcHoNpJ6Bg8N1vaxdIga166yzQdmsjzAVI13z6T/3+Jl5d4NjQGejI61VyFQZ4j/Ic
 DLR8IIFKaeUf/MLcl3mLOa/m+NPjhyIr0fPf+t9HM7mIBcxOq7cVXrDznHuhxfgGGmQC7Wuh9nQ
 ls7TRglewyXOcgSBn8DFaN4gc39yhOBZY8TJK8CuVzgQu+lYwu49TDRAAdABgFL2I5dT7oiANDt
 ymbjX/Z6J72hX0I+wFTLyiBtptgpZw1eIUjxVzdgy8ed+edsNCTifaeXa8buLpx5BaVBUGU4+qN
 7vPnz0t8FOW0cX+JMk9XHQspwwhmgFoexxptjQCM=
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a9b062a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=jldH35smy0nQoxfUp5IA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101
X-Proofpoint-GUID: jXUH9hFuxjT4XbU59qtQoreu8BjKnino
X-Proofpoint-ORIG-GUID: jXUH9hFuxjT4XbU59qtQoreu8BjKnino

v1: https://lore.kernel.org/all/20260816053630.527528-1-dongli.zhang@oracle.com

v1->v2:
  - move the last_steal field in the main vcpu structure (suggested by
    Marc Zyngier).
  - Reset last_steal from the caller of kvm_arch_vcpu_run_pid_change().

KVM does not support vCPU hotplug. When a vCPU is removed, its
corresponding data structures are not freed by KVM. Instead, QEMU destroys
only the userspace state and the vCPU thread, while the KVM vCPU fd remains
open and parked in QEMU.

As a result, vcpu->arch.st.last_steal is not reset. If the same vCPU is
later re-created by QEMU, last_steal retains its old value, while
current->sched_info.run_delay starts from zero since a new vCPU thread is
created. This causes current->sched_info.run_delay - vcpu->arch.st.last_steal
to produce a large, bogus value.

For instance, current->sched_info.run_delay can become smaller than
vcpu->arch.st.last_steal (see line 3804) if a QEMU vCPU is re-added after
it has previously been removed.

As a result, st->steal restarts from a very small value, close to
current->sched_info.run_delay.

3720 static void record_steal_time(struct kvm_vcpu *vcpu)
3721 {
... ...
3803         unsafe_get_user(steal, &st->steal, out);
3804         steal += current->sched_info.run_delay -
3805                 vcpu->arch.st.last_steal;
3806         vcpu->arch.st.last_steal = current->sched_info.run_delay;
3807         unsafe_put_user(steal, &st->steal, out);


This patchset resets last_steal when the vCPU PID changes, as suggested by
Sean.

Although David suggested accounting the run_delay left over from the
previous vCPU PID, this series does not do that. It would be easy to make
that work if KVM could simply assume every transition is a vCPU PID change.
In practice, KVM does not always have enough information about the previous
vCPU PID, e.g. after live migration, unless a new ioctl is introduced. For
now, this series simply resets last_steal.

Although David also suggested doing the same for Xen-on-KVM vCPUs, this
series does not reset last_steal for Xen vCPUs. That change itself would
not be difficult, but Xen uses a different mechanism to account downtime,
including runnable time and offline time when a vCPU is not running. It may
therefore need no additional ioctl, or a smaller ioctl extension, to account
run_delay left over from the previous PID.

As I have access to only x86 and arm64 KVM hosts, I created and validated
the selftest on those two architectures only.

Dongli Zhang (4)
  KVM: Move last_steal to common struct kvm_vcpu
  KVM: Reset last_steal on vCPU pid change
  KVM: selftests: Test steal time across vCPU pid changes on x86
  KVM: selftests: Add arm64 coverage for steal time pid changes

 arch/arm64/include/asm/kvm_host.h               |   1 -
 arch/arm64/kvm/Kconfig                          |   1 +
 arch/arm64/kvm/pvtime.c                         |   8 +-
 arch/loongarch/include/asm/kvm_host.h           |   1 -
 arch/loongarch/kvm/Kconfig                      |   1 +
 arch/loongarch/kvm/exit.c                       |   2 +-
 arch/loongarch/kvm/vcpu.c                       |   6 +-
 arch/riscv/include/asm/kvm_host.h               |   1 -
 arch/riscv/kvm/Kconfig                          |   1 +
 arch/riscv/kvm/vcpu_sbi_sta.c                   |  10 +-
 arch/x86/include/asm/kvm_host.h                 |   1 -
 arch/x86/kvm/Kconfig                            |   1 +
 arch/x86/kvm/x86.c                              |   5 +-
 include/linux/kvm_host.h                        |   4 +
 tools/testing/selftests/kvm/Makefile.kvm        |   2 +
 .../selftests/kvm/steal_time_change_pid.c       | 216 +++++++++++++++++++
 virt/kvm/Kconfig                                |   3 +
 virt/kvm/kvm_main.c                             |   4 +
 18 files changed, 248 insertions(+), 20 deletions(-)

base-commit: 8ab1afb2eb246ab15b301cd255b5943d208a93c1

Thank you very much!

Dongli Zhang

