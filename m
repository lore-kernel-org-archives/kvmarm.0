From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 1/3] update-linux-headers.sh: export virtio_types.h
Date: Wed, 04 Mar 2015 16:40:36 +0100
Message-ID: <54F72774.8080906@linaro.org>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
 <1425478577-32556-2-git-send-email-eric.auger@linaro.org>
 <20150304153756.GA5890@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55A2C47B08
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 10:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5d2MlXLKt4tr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 10:36:57 -0500 (EST)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5130947B02
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 10:36:57 -0500 (EST)
Received: by wibhm9 with SMTP id hm9so8435674wib.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 07:42:59 -0800 (PST)
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: patches@linaro.org, qemu-devel@nongnu.org, eric.auger@st.com, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 03/04/2015 04:37 PM, Michael S. Tsirkin wrote:
> On Wed, Mar 04, 2015 at 02:16:15PM +0000, Eric Auger wrote:
>> virtio_ring.h now includes virtio_types.h. update-linux-headers.sh
>> now exports this latter.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> This is already included in my tree, but in a different place.
> Pull request sent today, pls wait for it to be pulled, don't
> apply this one.

OK Thanks

- Eric
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
