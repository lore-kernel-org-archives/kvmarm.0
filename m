From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v12 3/4] hw/arm/virt: add dynamic sysbus device support
Date: Mon, 27 Apr 2015 16:05:16 +0200
Message-ID: <553E421C.50207@suse.de>
References: <1429888773-11730-1-git-send-email-eric.auger@linaro.org>
 <1429888773-11730-4-git-send-email-eric.auger@linaro.org>
 <553E3C71.1040001@suse.de>
 <CAFEAcA_2FYR3A6Y5oSACEQG6+W7CBJfFpxoDzLyxiqM-KQv6hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9DC4E99C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lyJfBUE0YKPX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 09:58:50 -0400 (EDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B95E4E98F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:58:50 -0400 (EDT)
In-Reply-To: <CAFEAcA_2FYR3A6Y5oSACEQG6+W7CBJfFpxoDzLyxiqM-KQv6hg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/27/2015 03:56 PM, Peter Maydell wrote:
> On 27 April 2015 at 14:41, Alexander Graf <agraf@suse.de> wrote:
>> Peter, would you have a hard time if we just get rid of VIRT_MMIO completely
>> and allow users to create the mmio-virtio bridges using -device for -M
>> virt-2.4 and above?
> I would strongly prefer not -- it breaks existing working command
> lines. I agree that we are going to want to move to virtio-pci
> and virtio-mmio is just legacy, but retaining legacy is what makes
> QEMU not kvmtool, right? :-)

Heh ;). Oh well, I guess the series is ready to go in then. I'd still 
like to see the virtio-mmio bridge get enabled for dynamic platform bus 
support soon, so that we can eventually phase out the preallocated region.


Alex
