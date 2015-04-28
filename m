From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Tue, 28 Apr 2015 09:01:10 +0200
Message-ID: <553F3036.9080903@linaro.org>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>	<553DF2AA.2070102@linaro.org>	<553E11E7.7070704@redhat.com>	<553E297F.4020706@linaro.org>	<553E3B7E.9080009@redhat.com>	<CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>	<553E4E05.1010405@linaro.org>	<553E4F2D.7060808@redhat.com>	<CAEgOgz61=-jvDGg7BWWAJSVCceaCJ21t_7jjqF_H_B5BuhVdXg@mail.gmail.com>	<553F2CA9.90303@linaro.org>
 <CAEgOgz6rbVnFiSYeyCt0yABCtqFWu8w7kPYcTM4_Bmt35uodbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024A44EC85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:55:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FwxJajmHA53Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 02:55:24 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35C7C4EC84
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:55:23 -0400 (EDT)
Received: by wgso17 with SMTP id o17so140484144wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 00:03:49 -0700 (PDT)
In-Reply-To: <CAEgOgz6rbVnFiSYeyCt0yABCtqFWu8w7kPYcTM4_Bmt35uodbg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2015 08:57 AM, Peter Crosthwaite wrote:
> On Mon, Apr 27, 2015 at 11:46 PM, Eric Auger <eric.auger@linaro.org> wrote:
>> Hi Peter,
>>
>> On 04/27/2015 07:43 PM, Peter Crosthwaite wrote:
>>> On Mon, Apr 27, 2015 at 8:01 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>
>>>>
>>>> On 27/04/2015 16:56, Eric Auger wrote:
>>>>> Peter, Paolo,
>>>>>
>>>>> After your feedbacks, I feel I need to spend some more time on the
>>>>> original check() track. I would prefer not to introduce any patch that
>>>>> will make issue in the future.
>>>>
>>>> Peter, see the other threads between me and Eric.  See in particular
>>>> http://lists.gnu.org/archive/html/qemu-devel/2015-04/msg02749.html
>>>> starting at "The notifier actually is not even necessary" and the
>>>> replies from there.
>>>>
>>>
>>> Thanks,
>>>
>>> I see the problem with check. In this reply
>>>
>>> http://lists.gnu.org/archive/html/qemu-devel/2015-04/msg02956.html
>>>
>>> Eric says that the problem with the check hook is it happens before
>>> the setting. I think this can be solved with a RYO link setter for
>>> GPIOs. We almost have an in-tree precedent with MemoryRegion and the
>>> container property (memory.c):
>>>
>>>  960     op = object_property_add(OBJECT(mr), "container",
>>>  961                              "link<" TYPE_MEMORY_REGION ">",
>>>  962                              memory_region_get_container,
>>>  963                              NULL, /* memory_region_set_container */
>>>  964                              NULL, NULL, &error_abort);
>>>
>>> Now in reality we could have done this link normal style as it is only
>>> a trivial getter, but the reason the link was done this way in the
>>> first place, is because I have a follow up patch to memory.c that adds
>>> a customer Link setter:
>>>
>>> +static void memory_region_set_container(Object *obj, Visitor *v, void *opaque,
>>> +                                        const char *name, Error **errp)
>>> +{
>>> +    MemoryRegion *mr = MEMORY_REGION(obj);
>>> +    Error *local_err = NULL;
>>> +    MemoryRegion *old_container = mr->container;
>>> +    MemoryRegion *new_container = NULL;
>>> +    char *path = NULL;
>>> +
>>> +    visit_type_str(v, &path, name, &local_err);
>>> +
>>> +    if (!local_err && strcmp(path, "") != 0) {
>>> +        new_container = MEMORY_REGION(object_resolve_link(obj, name, path,
>>> +                                      &local_err));
>>> +        while (new_container->alias) {
>>> +            new_container = new_container->alias;
>>> +        }
>>> +    }
>>> +
>>> +    if (local_err) {
>>> +        error_propagate(errp, local_err);
>>> +        return;
>>> +    }
>>> +
>>> +    object_ref(OBJECT(new_container));
>>> +
>>> +    memory_region_transaction_begin();
>>> +    memory_region_ref(mr);
>>> +    if (old_container) {
>>> +        memory_region_del_subregion(old_container, mr);
>>> +    }
>>> +    mr->container = new_container;
>>> +    if (new_container) {
>>> +        memory_region_update_container_subregions(mr);
>>> +    }
>>> +    memory_region_unref(mr);
>>> +    memory_region_transaction_commit();
>>> +
>>> +    object_unref(OBJECT(old_container));
>>> +}
>>> +
>>>
>>>      op = object_property_add(OBJECT(mr), "container",
>>>                               "link<" TYPE_MEMORY_REGION ">",
>>>                               memory_region_get_container,
>>> -                             NULL, /* memory_region_set_container */
>>> +                             memory_region_set_container,
>>>                               NULL, NULL, &error_abort);
>>>
>>>
>>> The function does the normal link setting - similar to
>>> object_set_link_property (not to be confused with
>>> object_property_set_link!) but is surrounded by class specific side
>>> effects. Specifically in this case, it does
>>> memory_region_transaction_begin/ref/unref/commit etc for the MR.
>>>
>>> For this GPIO case, you could create a custom setter that does the
>>> normal set, then calls the DeviceClass installed hook (or you can
>>> install the hook to the object and init it at qdev_init_gpio_out_named
>>> time as suggested in the eariler thread). The callback will happen
>>> after the link is populated.
>>>
>>> To reduce verbosity, I suggest making object_set_link_property() a
>>> visible API, then RYO link setters can call it surrounded by custom
>>> behavior e.g:
>>>
>>> foo_object_set_bar_property(...)
>>> {
>>>     pre_set_link_side_effects();
>>>     object_set_link_property();
>>>     post_set_link_side_effects();
>>> }
>>>
>>> object_set_link_property() would need to be coreified and wrapped to
>>> remove it's awareness of LinkProperty type (as that doesn't exist in
>>> RYO properties) in this case.
>>
>> Thank you Peter for detailing this.
>>
>> Yesterday I re-worked on the solution based on the check() method where
>> - check would take a Object **child as a 3d parameter
>> - we would assign *child before the call and in case the check fails set
>> the *child back to NULL in object_set_link_property.
>>
> 
> I think this is starting to reach outside the design intent of the
> check, letting it be an API that takes over the responsibility of
> ->set. Ideally check should be boolean and side-effectless.
I acknowledge ;-)
> 
>> I need to do some more testing.
>>
>> I don't know if this solution would be acceptable too. If not I will
>> implement according to your guidelines.
>>
> 
> Lets see what Paolo says before another rework.
sure

Thanks

Eric
> 
> Regards,
> Peter
> 
>> Best Regards
>>
>> Eric
>>>
>>> Regards,
>>> Peter
>>>
>>>> If you have any idea, please help.
>>>>
>>>> Paolo
>>>>
>>
>>
