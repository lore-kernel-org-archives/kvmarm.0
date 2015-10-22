From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 5/6] vfio: platform: use list of registered reset
 function
Date: Thu, 22 Oct 2015 13:46:27 +0200
Message-ID: <5628CC93.7000801@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <1445506922-6005-6-git-send-email-eric.auger@linaro.org>
 <20554656.kA5nRBgtaJ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7786F412AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 07:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PEqXTv5onPXw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 07:43:52 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 917EF40FAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 07:43:52 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so131388337wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 04:46:29 -0700 (PDT)
In-Reply-To: <20554656.kA5nRBgtaJ@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/22/2015 12:19 PM, Arnd Bergmann wrote:
> On Thursday 22 October 2015 11:42:01 Eric Auger wrote:
>> Remove the static lookup table and use the dynamic list of registered
>> reset functions instead. Also load the reset module through its alias.
>> The reset struct module pointer is stored in vfio_platform_device.
>>
>> We also remove the useless struct device pointer parameter in
>> vfio_platform_get_reset.
>>
>> This patch fixes the issue related to the usage of __symbol_get, which
>> besides from being moot, prevented compilation with CONFIG_MODULES
>> disabled.
>>
>> Also usage of MODULE_ALIAS makes possible to add a new reset module
>> without needing to update the framework. This was suggested by Arnd.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
> 
> Looks good, just small style issues:
> 
>>
>> -			}
>> +	mutex_lock(&reset_lock);
>> +	list_for_each_entry(iter, &reset_list, link) {
>> +		if (!strcmp(iter->compat, compat) &&
>> +			try_module_get(iter->owner)) {
>> +			*module = iter->owner;
>> +			mutex_unlock(&reset_lock);
>> +			return iter->reset;
>>  		}
>>  	}
>> +
>> +	mutex_unlock(&reset_lock);
>> +	return NULL;
> 
> Better use 'break' to have a single mutex_unlock and return  statement.
OK
> 
>> +
>>  
>>  static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
>>  {
>> -	if (vdev->reset)
>> -		symbol_put_addr(vdev->reset);
>> +	if (vdev->reset) {
>> +		module_put(vdev->reset_module);
>> +		vdev->reset_module = NULL;
>> +		vdev->reset = NULL;
>> +	}
>>  }
> 
> This gets called from the remove callback. No need to clear those
> struct members immediately before the kfree().
I should have added those assignments in next patch actually. This
latter moves the vfio_platform_put_reset call in the release function.

Best Regards

Eric
> 
> 	Arnd
> 
