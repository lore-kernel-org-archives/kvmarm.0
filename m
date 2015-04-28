From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] sysbus: add irq_routing_notifier
Date: Tue, 28 Apr 2015 11:04:39 +0200
Message-ID: <553F4D27.7010306@redhat.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>	<553DF2AA.2070102@linaro.org>	<553E11E7.7070704@redhat.com>	<553E297F.4020706@linaro.org>	<553E3B7E.9080009@redhat.com>	<CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>	<553E4E05.1010405@linaro.org>	<553E4F2D.7060808@redhat.com>
	<CAEgOgz61=-jvDGg7BWWAJSVCceaCJ21t_7jjqF_H_B5BuhVdXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <CAEgOgz61=-jvDGg7BWWAJSVCceaCJ21t_7jjqF_H_B5BuhVdXg@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, Eric Auger <eric.auger@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 27/04/2015 19:43, Peter Crosthwaite wrote:
> To reduce verbosity, I suggest making object_set_link_property() a
> visible API, then RYO link setters can call it surrounded by custom
> behavior e.g:
> 
> foo_object_set_bar_property(...)
> {
>     pre_set_link_side_effects();
>     object_set_link_property();
>     post_set_link_side_effects();
> }
> 
> object_set_link_property() would need to be coreified and wrapped to
> remove it's awareness of LinkProperty type (as that doesn't exist in
> RYO properties) in this case.

I agree with this, but I think it can be done separately from Eric's work.

Paolo
