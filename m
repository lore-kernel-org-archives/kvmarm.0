From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: use vnc in arm-kvm
Date: Thu, 17 May 2018 08:41:48 +0100
Message-ID: <f2b07625-5ede-4a95-2e62-ba5c64c2d3db@arm.com>
References: <ADcAHQC3AeXOwvscMuFdTao0.3.1526518708101.Hmail.lizhuoyao@hikdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C244A0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 May 2018 03:31:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7b93FqE0KRi3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 May 2018 03:31:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C92149EA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 May 2018 03:31:29 -0400 (EDT)
In-Reply-To: <ADcAHQC3AeXOwvscMuFdTao0.3.1526518708101.Hmail.lizhuoyao@hikdata.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lizhuoyao <lizhuoyao@hikdata.com>
Cc: kvmarm@lists.cs.columbia.edu, shengyizju <shengyizju@163.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/05/18 01:58, lizhuoyao wrote:
> you said VGA cannot be realistically supported on ARM at the moment,then
> wrote it's ok checked with VNC.Did you experiment in x86 or arm?

What would be the point in trying an x86 box, as we both know that it
works? I checked using virtio-gpu, on an arm64 machine (rk3399 based
chromebook). Not x86, not VGA.

> There is likely no -device(--device) parameter in "virt-install -h".
> Sorry, I'm not familiar with virt-install much. Can you show the order
> you use?

OK, you simply haven't read my email. I said:

>> It works well enough for me, although I do not use libvirt, and
>> stick to just qemu. For the record, this is the relevant section of
>> my command line:

To repeat: I don't use libvirt, but QEMU directly. If you have libvirt
questions, please do as Laszlo suggested and ask the question on the
libvirt mailing list.

	M.
-- 
Jazz is not dead. It just smells funny...
