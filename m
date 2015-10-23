From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 2/7] vfio: platform: add capability to register a reset
 function
Date: Fri, 23 Oct 2015 16:15:06 +0200
Message-ID: <562A40EA.40706@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <1445603835-14506-3-git-send-email-eric.auger@linaro.org>
 <5723752.hDK15zeNcm@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46302410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 10:12:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QEac90VekYsO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 10:12:28 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AB7D41049
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 10:12:28 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so33347547wic.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 07:15:08 -0700 (PDT)
In-Reply-To: <5723752.hDK15zeNcm@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/23/2015 03:07 PM, Arnd Bergmann wrote:
> On Friday 23 October 2015 14:37:10 Eric Auger wrote:
>> +
>> +void vfio_platform_unregister_reset(const char *compat)
>> +{
>> +       struct vfio_platform_reset_node *iter, *temp;
>> +
>> +       mutex_lock(&driver_lock);
>> +       list_for_each_entry_safe(iter, temp, &reset_list, link) {
>> +               if (!strcmp(iter->compat, compat)) {
>> +                       list_del(&iter->link);
>> +                       break;
>> +               }
>> +       }
>> +
>> +       mutex_unlock(&driver_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
>>
> 
> This is slightly unsafe in case you ever get two drivers that register
> with the same compat string. If we care about that, we could pass
> and compare both the string and the function pointer, or the
> vfio_platform_reset_node.
OK

Thanks

Eric
> 
> 	Arnd
> 
