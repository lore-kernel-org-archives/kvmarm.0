From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: use vnc in arm-kvm
Date: Wed, 16 May 2018 11:16:16 +0200
Message-ID: <031a488d-2c26-0742-e7e5-51439b3faffe@redhat.com>
References: <AHwADAAHAYrOX6gNq*WMHKrQ.1.1526437495977.Hmail.lizhuoyao@hikdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D966940196
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rXM-1X9rtUHE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 05:06:00 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 206FD400D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:06:00 -0400 (EDT)
In-Reply-To: <AHwADAAHAYrOX6gNq*WMHKrQ.1.1526437495977.Hmail.lizhuoyao@hikdata.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lizhuoyao <lizhuoyao@hikdata.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/16/18 04:24, lizhuoyao wrote:
> hi everyone:
>   currently, I meet a problem about qemu.Use virt-install order to create a domain, return a failed:
>   order: virt-install -n centos-gg -r 1024 --disk centos-gg.img,format=qcow2,size=10 --cdrom /home/Centos-7-aarch64-Everything.iso --graphics vnc, listen=0.0.0.0
>     failed: this QEMU does not support 'cirrus' video device
>    This issue only happen in arm,and it's ok in x86. I get some message in the internet that VGA is a (more or less) x86-specific standard, not available on ARM. Right?
> tool: qemu-2.12.0 libvirt-3.2.0

Please select the "virtio" video device model.

(Also, the kvmarm list is not appropriate for discussing this; please
use <https://www.redhat.com/mailman/listinfo/virt-tools-list> or
<https://www.redhat.com/mailman/listinfo/libvirt-users> instead.)

Thanks
Laszlo
