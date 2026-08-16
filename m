Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560833C198
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786858889; cv=none; b=lZgcE/zgYj4ynU7fc4zBUD0IaJ7mJnDhSJSdPZlCWqVAdkbuoLbccsr7UDdblqvt012aN++o63vcWkADYjZWXmD0jIu5hnzezmMWmHbd/0cFBXl0/fPE7ZgmZak0xxnCV5JentAG8TFr6YhJy+WU62zYkASy/6hFmyTNxn45sKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786858889; c=relaxed/simple;
	bh=wBBhpjt9dzv4hRA2sOo75BTjLCdd0Tnawc/rHhRDPw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dO/w1fz42ogstA2nDGo5PczGMcS+TcG2/HHiLHpv5T+GIvnJ0HULBzlYefXva1VKK/xRmR0lxxrZiW+cjHNKK0eVs368VSJKZUCV5tR8ymTOgTgBUjMDWWNUbRpu1WpoSLqzKHonB9vWh4IUnUlGYr0LIdaJ9abIJTdOZMrJwaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bY8+eqB8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bY8+eqB8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67G5OXtM2035357;
	Sun, 16 Aug 2026 05:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=r2J9JgQhkLHvjLeRmeT0qNNRndodC
	l+R5/yh+PljVnQ=; b=bY8+eqB8QzJlLFOCCP1D2k2I5Hj/wd9f8tvRk0VRkcX2a
	s2lHr3h8ToQynAxRaz3/98O3VlI82qVFaqHHYeF7kQ0tRaWcc/DuWOgddlOl8oj3
	lDdPqzb47tsHu9VpVp6jpqDEnXpMxmrc0fKVPolDQRsYSWTXvkde6yBhdnDfECtj
	k6BEniOA3uolJF8eKu0LEB3D0h3JIobCu5EkVyIa8unZk3gQPWmC9EbijHVVtF32
	GOn0ivXhFxSbXoymSJ52MaKuyEz3SxGRO6pyc6sJXSe+Ob3GykMywcmDhqUQ1z78
	auJX4ztOsEhR6RFUZJT7Cf2owOmTroqSQ6+K0u9jw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2f1brv5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67G5e9Jw011028;
	Sun, 16 Aug 2026 05:40:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejammbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:53 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67G5ereT012353;
	Sun, 16 Aug 2026 05:40:53 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejammbp-1;
	Sun, 16 Aug 2026 05:40:53 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, dwmw2@infradead.org,
        joe.jin@oracle.com
Subject: [PATCH 0/4] KVM: Reset steal time accounting on vCPU pid change (x86 and arm64)
Date: Sat, 15 Aug 2026 22:33:01 -0700
Message-ID: <20260816053630.527528-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608160039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX9/Lk+lcRitS5
 0mP3cqxr3xqPvVUpon+JekmKkr3Wb9U3a1N5ClxTauVmQ8G7uAvBsZF9B4riIAo8NkLAiIP1Dwf
 1AK74LiMvzWs03X2raZSdaCBavLi4gMkfQzFxhRJy3Wg+eEF2P5CMBrQ/UynABAEyBKku/zhQwq
 OhRdXGKPU0yh+VT10FGVefXxaFbfra8GhkZmxVsMPiIda+f8YHvA47i4bRXvHMtaUH67z95WmwA
 lsk4uNQOvk2jua6Tnj5BwZdy3qUFPxpAkdXoOiGe8GAi+dVJqlU6Nm4h2g8EvQzg2TU3Mi0ninW
 A3Nh8nAJ7Z6iH83Pi58AJsIPJ+3RmVintx0a6xsINGgV12QA/XdzS/GCMxt9OeJSKreU56XXwhH
 X2f7s45fKE/rtZLZravC+yflBNKQAlZ7mINF7OZrnk6wVrOzuNiGnuNpqUInDe3iFMFCi3inhHO
 PqnEEykiPK5MdCjIPJA==
X-Authority-Analysis: v=2.4 cv=D/937PRj c=1 sm=1 tr=0 ts=6a814d66 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=DtIxHsc76qG4-ebJFCwA:9
X-Proofpoint-ORIG-GUID: QBcnolLFr_s4KGrVbr09-cz7HZp28BHw
X-Proofpoint-GUID: QBcnolLFr_s4KGrVbr09-cz7HZp28BHw
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX+Wy9tqOnhA9t
 kGW4yBgwGPYhcrW0jh5sBW/jIWDBoasrR9mXB40c1ztq6FSPV/CglWWa1X0HDGujqdTkqc4Xn4b
 7KIZuQ4BNKavMgfZ3Mhm9zxz0K5GjKaqxaZwB7uDk3S/8hyN21zH

I previously sent the patchset below, but I am not sending this series as
v2 because the topic has changed significantly.

[PATCH 0/5] Fix and enhance KVM steal accounting for both guest and host
https://lore.kernel.org/all/20260505003044.78693-1-dongli.zhang@oracle.com

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


This patchset:

1. Resets vcpu->arch.st.last_steal when the vCPU PID changes, as suggested
by Sean. Both x86 and arm64 are supported.

2. Although David suggested accounting the run_delay left over from the
previous vCPU PID, this series does not do that. It would be easy to make
that work if KVM could simply assume every transition is a vCPU PID change.
In practice, KVM does not always have enough information about the previous
vCPU PID, e.g. after live migration, unless a new ioctl is introduced. For
now, this series simply resets last_steal.

3. Although David also suggested doing the same for Xen-on-KVM vCPUs, this
series does not reset last_steal for Xen vCPUs. That change itself would
not be difficult, but Xen uses a different mechanism to account downtime,
including runnable time and offline time when a vCPU is not running. It may
therefore need no additional ioctl, or a smaller ioctl extension, to account
run_delay left over from the previous PID. For now, this series changes only
regular x86 steal time and arm64 PV time.

4. Guest kernel changes are not included. I may send it separately to keep
this series limited to the KVM hypervisor.

[PATCH 1/5] x86/kvm: Reset prev_steal_time and prev_steal_time_rq when enabling steal time
https://lore.kernel.org/all/20260505003044.78693-2-dongli.zhang@oracle.com

5. There is one remaining corner case: this series resets last_steal when
the vCPU run PID changes, but not when steal time is enabled. If additional
host run_delay is accumulated after the PID changes but before the guest
enables steal time, that delta could be unexpectedly accounted to guest
vCPU steal time. In practice, this should not happen for Linux guests.


Dongli Zhang (4)
  KVM: x86: Reset last_steal on vCPU pid change
  KVM: arm64: Reset last_steal on vCPU pid change
  KVM: selftests: Test steal time across vCPU pid changes on x86
  KVM: selftests: Add arm64 coverage for steal time pid changes

 arch/arm64/include/asm/kvm_host.h               |   1 +
 arch/arm64/kvm/arm.c                            |   2 +
 arch/arm64/kvm/pvtime.c                         |   5 +
 arch/x86/kvm/Kconfig                            |   1 +
 arch/x86/kvm/x86.c                              |   7 +
 tools/testing/selftests/kvm/Makefile.kvm        |   2 +
 .../selftests/kvm/steal_time_change_pid.c       | 216 +++++++++++++++++++
 7 files changed, 234 insertions(+)

base-commit: 3eb40771c00a8488fa6ed2cc1fe203477908bf38

Thank you very much!

Dongli Zhang

