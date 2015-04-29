From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v14 01/10] linux-headers: update headers according to
 4.1-rc1
Date: Wed, 29 Apr 2015 17:28:25 +0200
Message-ID: <5540F899.6050700@linaro.org>
References: <1430319127-25907-1-git-send-email-eric.auger@linaro.org>	<1430319127-25907-2-git-send-email-eric.auger@linaro.org>
 <20150429171920.5cbfb7c7.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B58F4EF52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 11:22:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYrmr2yLd4tk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 11:22:36 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 616EE4EF51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 11:22:35 -0400 (EDT)
Received: by widdi4 with SMTP id di4so70395675wid.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 08:31:04 -0700 (PDT)
In-Reply-To: <20150429171920.5cbfb7c7.cornelia.huck@de.ibm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: peter.crosthwaite@xilinx.com, eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, borntraeger@de.ibm.com, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 04/29/2015 05:19 PM, Cornelia Huck wrote:
> On Wed, 29 Apr 2015 15:51:58 +0100
> Eric Auger <eric.auger@linaro.org> wrote:
> 
>> This updates linux-headers against master 4.1-rc1 (commit
>> b787f68c36d49bb1d9236f403813641efa74a031).
>>
>> This includes, among other things, VFIO platform driver and
>> irqfd/arm.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>> v13 -> v14:
>> - update to precise 4.1-rc1, precise the commit and change the title
>>
>> v12 -> v13:
>> - update for 4.1-rc0 headers
>>
>> v10 -> v11:
>> - only includes header modifications related to vfio platform
>>   driver v14 and not those related to
>>   "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1"
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  include/standard-headers/linux/virtio_balloon.h |  28 +++-
>>  include/standard-headers/linux/virtio_blk.h     |   8 +-
>>  include/standard-headers/linux/virtio_ids.h     |   1 +
>>  linux-headers/asm-arm/kvm.h                     |   9 +-
>>  linux-headers/asm-arm64/kvm.h                   |   9 +-
>>  linux-headers/asm-mips/kvm.h                    | 164 +++++++++++++++---------
>>  linux-headers/asm-s390/kvm.h                    |   4 +
>>  linux-headers/asm-x86/hyperv.h                  |   2 +
>>  linux-headers/linux/kvm.h                       |  66 +++++++++-
>>  linux-headers/linux/vfio.h                      |   2 +
>>  10 files changed, 223 insertions(+), 70 deletions(-)
> 
> Not trying to be a pain, but have you figured out why the virtio-input
> header is missing for you?
Yep sorry I need to clean my untracked files in my git :-(

Eric
> 
