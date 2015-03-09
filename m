From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [Qemu-devel] [PATCH v4 1/3] update-linux-headers.sh: export
 virtio_types.h
Date: Mon, 09 Mar 2015 10:26:58 +0100
Message-ID: <54FD6762.9080208@de.ibm.com>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
 <1425478577-32556-2-git-send-email-eric.auger@linaro.org>
 <20150304153756.GA5890@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00F948148
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 05:20:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NBNfLj9JpR-2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 05:20:50 -0400 (EDT)
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96992480FF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 05:20:49 -0400 (EDT)
Received: from /spool/local
 by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Mon, 9 Mar 2015 09:27:03 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5269817D8056
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 09:27:21 +0000 (GMT)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com
 [9.149.37.217])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t299QxWd19398842
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Mar 2015 09:27:00 GMT
Received: from d06av06.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t294M80h005382
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Mar 2015 00:22:08 -0400
In-Reply-To: <20150304153756.GA5890@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Michael S. Tsirkin" <mst@redhat.com>, Eric Auger <eric.auger@linaro.org>
Cc: patches@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, pbonzini@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Am 04.03.2015 um 16:37 schrieb Michael S. Tsirkin:
> On Wed, Mar 04, 2015 at 02:16:15PM +0000, Eric Auger wrote:
>> virtio_ring.h now includes virtio_types.h. update-linux-headers.sh
>> now exports this latter.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> This is already included in my tree, but in a different place.
> Pull request sent today, pls wait for it to be pulled, don't
> apply this one.

The s390 tree also depends on the header update. So if my vote counts,
I prefer to have that pull request sorted out sooner than later.

Peter, welcome back :-)




> 
> 
> 
>> ---
>>  scripts/update-linux-headers.sh | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
>> index c8e026d..bbe6185 100755
>> --- a/scripts/update-linux-headers.sh
>> +++ b/scripts/update-linux-headers.sh
>> @@ -62,7 +62,7 @@ done
>>  rm -rf "$output/linux-headers/linux"
>>  mkdir -p "$output/linux-headers/linux"
>>  for header in kvm.h kvm_para.h vfio.h vhost.h virtio_config.h virtio_ring.h \
>> -              psci.h; do
>> +              virtio_types.h psci.h; do
>>      cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
>>  done
>>  rm -rf "$output/linux-headers/asm-generic"
>> -- 
>> 1.8.3.2
> 
