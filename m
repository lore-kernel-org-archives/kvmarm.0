From: Peter Maydell <peter.maydell@linaro.org>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=5BPATCH_v6_4=2F7=5D_arm64=3A_kvm=3A_support_user_?=
 =?UTF-8?Q?space_to_query_RAS_extension_feature?=
Date: Fri, 8 Sep 2017 16:03:21 +0100
Message-ID: <CAFEAcA8tXV31RTa+RCkkNFyR2t1dTwR5kYXUmBXMj9wkeLWCpg@mail.gmail.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com>
 <59A84F9D.8030309@arm.com> <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
 <59B1747A.5030909@arm.com>
 <0184EA26B2509940AA629AE1405DD7F2015F5A1C@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7618749C61
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 11:01:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GasSz2IfavaC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 11:01:13 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F8BD49C41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 11:01:13 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id 137so6751300wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Sep 2017 08:03:43 -0700 (PDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015F5A1C@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Wangkefeng (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "mst@redhat.com" <mst@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 September 2017 at 15:34, gengdongjiu <gengdongjiu@huawei.com> wrote:
> Hi Peter/ shenglong,
>    What is your idea about it? We may need to consult with you about it.

I agree with what I take to be James' general point that we
should be careful to distinguish "KVM supports API A to
do a particular operation on the guest" and "KVM supports API
B to tell QEMU about certain events" and so on, and not just
lump these all together under "host CPU supports RAS and
so we turn all these on together and expose RAS to the guest
regardless". I don't know enough about the details of RAS
to be more specific than that general point of view.

PS: your mail client doesn't seem to be doing the right
thing with wrapping long lines :-(

thanks
-- PMM
