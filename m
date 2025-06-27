Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D242F3E
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751006119; cv=none; b=Ezwla0csNXV+9vOse1YZ5X4rE5TedT5so0OxsVAY5Yf8sP2OiuYexGzp/a0co+KTxOe2VSwGQ7+N7W4oVOFMdlg0kOOPAl6ZHWZkNWe52fjQmecJTG1/6qyuoiOOdb5/rpe/jHekvS7+4ADwhKDSEy5tbu91iZ9VHN2zX2W81C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751006119; c=relaxed/simple;
	bh=Xpd1lBEhRNyXGzNAi8QrOMXrLdy5M9IbpmVSy7Y4c9U=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=s9k94c/+Zwgjf0xeMwOOytVnm0rCdj0kss4uknvunin5CRHHp8q12lRTXsAR36bDTC1DDnf5TRx0jMfJ4pMTHAhNGndc5Pj1oZoAuHwe1bE/lJ3b698yfIRiVMt1/cRgO9+QDlMxUb2y0RkEYbrrqTMm4bsZS2NhQNZcuv8Qa3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nVYfbuVd; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nVYfbuVd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751006114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WlZz1+Hu+Xkr/zc0iiKqz67hEmp96xoyRVekf6ZBEmo=;
	b=nVYfbuVdNDHDio0fcSLf3I3jfdAIjuHLUaelcBj1QerwFkiamcFTcf0mIwuLLieR/copfJ
	kvbuSs6Oro2/bF9MbYuEfeJ5cyD1J4CalZS7b3BzS/UXu/Cyp/GxupatHT9VOVA1P+YxC6
	vS93D/3tN387KjOmxdpruZ4MPzwaH2Y=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: kselftest kvm/arm/page_fault_test hangs if pagesize is 16KB
Message-Id: <B4C0AC3E-6A4F-4A7B-B7BC-81207539115E@linux.dev>
Date: Fri, 27 Jun 2025 15:34:57 +0900
To: kvmarm@lists.linux.dev
X-Migadu-Flow: FLOW_OUT

Hi,

Today=E2=80=99s master kvm kselftest page_fault_test hangs in QEMU TCG =
mode and -cpu max type.
Below is the call trace obtained by echo l > /proc/sysrq-trigger:

[ 7179.811953] CPU: 0 UID: 0 PID: 1091 Comm: page_fault_test Not tainted =
6.16.0-rc3-00188-g6f2a71a99ebd #29 PREEMPT
[ 7179.812005] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 =
02/06/2015
[ 7179.812029] pstate: 40402009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
[ 7179.812063] pc : arch_local_irq_enable+0x8/0x34
[ 7179.812104] lr : kvm_arch_vcpu_ioctl_run+0x984/0xad0
[ 7179.812125] sp : ffff800082d6baf0
[ 7179.812133] x29: ffff800082d6baf0 x28: ffff0000c63b2300 x27: =
0000000000000000
[ 7179.812190] x26: 0000000000000000 x25: 0000000000000000 x24: =
0000000000180400
[ 7179.812219] x23: 0000000000000001 x22: ffffce6f66e5f630 x21: =
ffff0000cddbf000
[ 7179.812248] x20: 0000000000000000 x19: ffff0000c6118000 x18: =
0000000000000000
[ 7179.812277] x17: 0000000000000000 x16: 0000000000000000 x15: =
0000000000000000
[ 7179.812305] x14: 0000000000000000 x13: 0000000000000000 x12: =
0000000000000000
[ 7179.812333] x11: 0000000000000000 x10: ffffce6f68835de0 x9 : =
1fffe00018171a41
[ 7179.812362] x8 : 0000000000000001 x7 : ffff0000c0b8d200 x6 : =
000000000000000f
[ 7179.812389] x5 : ffff0000c00dce30 x4 : ffff319295d92000 x3 : =
0000000000000000
[ 7179.812417] x2 : 0000000000000000 x1 : 0000000000000000 x0 : =
ffff0000c63b2300
[ 7179.812447] Call trace:
[ 7179.812457]  arch_local_irq_enable+0x8/0x34 (P)
[ 7179.812479]  kvm_vcpu_ioctl+0x1a0/0xaac
[ 7179.812498]  __arm64_sys_ioctl+0xac/0x104
[ 7179.812518]  invoke_syscall+0x48/0x110
[ 7179.812535]  el0_svc_common.constprop.0+0x40/0xe8
[ 7179.812553]  do_el0_svc+0x20/0x2c
[ 7179.812596]  el0_svc+0x38/0x124
[ 7179.812616]  el0t_64_sync_handler+0x144/0x168
[ 7179.812634]  el0t_64_sync+0x1ac/0x1b0

I checked testing with the 4KB and 64KB page sizes, page_fault_test runs =
fine.

Itaru.=
