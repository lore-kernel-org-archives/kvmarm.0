From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v13 10/12] qdev: check callback takes the property child
 as third argument
Date: Wed, 29 Apr 2015 10:37:04 +0200
Message-ID: <55409830.30303@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
 <1430239873-31950-11-git-send-email-eric.auger@linaro.org>
 <554094DF.3010607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4ED14EE9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 04:31:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xg1wOMyj+gbl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 04:31:15 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 547ED4ED74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 04:31:14 -0400 (EDT)
Received: by wizk4 with SMTP id k4so170879597wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 01:39:43 -0700 (PDT)
In-Reply-To: <554094DF.3010607@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, peter.crosthwaite@xilinx.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/29/2015 10:22 AM, Paolo Bonzini wrote:
> 
> 
> On 28/04/2015 18:51, Eric Auger wrote:
>> -    prop->check(obj, name, new_target, &local_err);
>> +    object_ref(new_target);
>> +    *child = new_target;
>> +
>> +    prop->check(obj, name, child, &local_err);
>>      if (local_err) {
>>          error_propagate(errp, local_err);
>> +        *child = old_target;
>> +        object_ref(new_target);
> 
> This should be an unref.

oups yes.

Thanks! Do I keep this series or do I revert to sysbus irq connect irq
temporary patch as per Peter's last email?

Eric
> 
> Paolo
> 
>>          return;
>>      }
>>  
>> -    object_ref(new_target);
>> -    *child = new_target;
>>      object_unref(old_target);
