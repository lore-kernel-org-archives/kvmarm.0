From: Antonios Motakis <antonios.motakis@huawei.com>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for a
 platform device
Date: Thu, 27 Aug 2015 15:36:15 +0200
Message-ID: <55DF124F.8020801@huawei.com>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
 <55DF07F0.3070405@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D188B48DC3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 09:36:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ei83Csj4toM0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Aug 2015 09:36:20 -0400 (EDT)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02C2C48D77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 09:36:19 -0400 (EDT)
In-Reply-To: <55DF07F0.3070405@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, alex.williamson@redhat.com, Baptiste
 Reynal <b.reynal@virtualopensystems.com>
Cc: tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

Hello Eric,

Myself I am not involved with anything VFIO related at the moment, so (alas=
) I don't have any plans to revisit this series.

If someone decides to pick it up, of course I can offer my feedback and sup=
port.

Cheers,
Antonios

On 27-Aug-15 14:52, Eric Auger wrote:
> Hi Baptiste, Antonios,
> =

> What are the plans wrt this series? I am currently integrating another
> QEMU VFIO platform devices where this series could be useful I think
> (Feb 2015). Do you intend to follow up and bring it upstream?
> =

> Alex, do you see some show-stoppers in this series or do you advise to
> simply follow-up?
> =

> Thank you in advance
> =

> Best Regards
> =

> Eric
> =

> =

> On 12/19/2014 10:20 PM, Antonios Motakis wrote:
>> This RFC's intention is to show what an interface to access device
>> properties for the VFIO platform driver can look like. These properties
>> can be from the device tree node describing the device, or ACPI properti=
es
>> in the future.
>>
>> If a device property corresponding to a platform device bound by VFIO PL=
ATFORM
>> or VFIO AMBA is available, this patch series will allow the user to query
>> for this information. This can be useful for userspace drivers to automa=
tically
>> query parameters related to the device.
>>
>> Specifically for QEMU, reading the "compatible" property of the device t=
ree
>> node could be of use to find out what device is being assigned to the gu=
est and
>> handle appropriately a wider range of devices in the future, and to gene=
rate an
>> appropriate device tree for the guest.
>>
>> Older versions of this series where specifically targeted at device tree
>> properties. This version has been reworked on top of Rafael J. Wysocki's
>> uniform device properties API for device tree and ACPI devices. This wil=
l allow
>> us to use the API in the future with devices described via ACPI.
>>
>> This also means a kernel including the uniform device properties API is =
needed
>> to apply these patches, in additon to the VFIO patches, e.g. branch pm+a=
cpi-3.19-rc1
>> from https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/
>>
>> The API to get the list of available properties and the device tree full=
_name
>> have been removed. These probably don't serve an useful purpose, as the =
user
>> of this API need to know anyway what properties are specific to the devi=
ce he
>> wants to access with VFIO. If we decide to reintroduce the list of prope=
rties
>> in the future, the generic device properties API in the kernel will have=
 to
>> be extended accordingly.
>>
>> A kernel with this series and all the dependencies applied can be pulled=
 from
>> branch vfio-device-properties-v3 from the repository:
>> https://github.com/virtualopensystems/linux-kvm-arm.git
>>
>> Changes since v2:
>>  - Reworked on top of Rafael J. Wysocki's uniform device properties API =
for
>>    device tree and ACPI
>>  - Support for u64 array properties
>>  - Removed API to get list of available properties and device tree full_=
name
>> Changes since v1:
>>  - Updated for VFIO platform patch series v8:
>>    VFIO AMBA devices now supported in addition to VFIO PLATFORM devices
>>  - Refactored and cleaned up the code
>>
>> Antonios Motakis (3):
>>   vfio: platform: add device properties skeleton and user API
>>   vfio: platform: access device property as a list of strings
>>   vfio: platform: return device properties as arrays of unsigned
>>     integers
>>
>>  drivers/vfio/platform/Makefile                |   3 +-
>>  drivers/vfio/platform/properties.c            | 162 +++++++++++++++++++=
+++++++
>>  drivers/vfio/platform/vfio_platform_common.c  |  35 ++++++
>>  drivers/vfio/platform/vfio_platform_private.h |   7 ++
>>  include/uapi/linux/vfio.h                     |  26 +++++
>>  5 files changed, 232 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/vfio/platform/properties.c
>>
> =


-- =

Antonios Motakis
Virtualization Engineer
Huawei Technologies Duesseldorf GmbH
European Research Center
Riesstrasse 25, 80992 M=FCnchen
