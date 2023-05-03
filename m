Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A4BE68
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 21:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683148701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t/bNA0LUE9HHsRFFEALcAbIeRaPUWYSG9GaTR6+obtI=;
	b=BlafyetnQ1pbTW6h7aNNRDBYt2M2OluTZ5k1B1cpuqiDCokwsxBsT1EDahhPD3UMKT1B55
	opgAxOKL0YEOcXanruykpaulGYedxX4cYbRNd58ZLxJ8JmU4LfWOwG2gLNFN70EyfpdP+3
	4tZyXMSoXZSwE+1YsXPfkSR7fkjdXe0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-8uqUF2ZrP9WNf4Za5Nh9aA-1; Wed, 03 May 2023 17:18:18 -0400
X-MC-Unique: 8uqUF2ZrP9WNf4Za5Nh9aA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3ef4f29c9d1so9613051cf.0
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 14:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683148698; x=1685740698;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZyvFarmbHofrNnRuQP6HdbNymlx/RJo0/9ImoEvaVk=;
        b=iQkSX7E0hSNxfzOwA+wKuQYTU6Q5Cg85XzsCki9EsxsHgVANkFHvyGMuj32+CA22op
         E+HgYznEcxBioJFFGUymf2C3trzagK3I5Qh/P5VwNhbHDDUf7nzhBS8s01u5aoSAVgZx
         Et1nBC5L/caRy/Wu+VuvrShiPAvsP81YT/IIF/dXif+MVIwx2wj+Dr7MqpP1ALRPG+Nz
         yanAhPhK6zp8UYaqeVCSVbNtWrVWpiLW8GM+/9hZg7fRHEWF4kguBNCvNBjiVJw7kMMn
         iy5p5Csx3OvNTgesu+BJGn1qVH07n7BJD31MSaTTcSpLp1ZgmgDwlDrkAD6un4M56u62
         7Ptg==
X-Gm-Message-State: AC+VfDyv/BqpydhxCAGxu1juLUvdaoyqtYnc9gRQZQU5czDGxkqoKTLi
	4GRh8LeqFKDeyu8gLfaH5HMSLK9/PcubCnSElZFrVGLEwnkX6uOkzz1jvswHgOkLX4WjMi/RFeT
	cDU0xJFoL6qF+TD8D
X-Received: by 2002:a05:622a:1824:b0:3eb:143a:746a with SMTP id t36-20020a05622a182400b003eb143a746amr12936247qtc.4.1683148698201;
        Wed, 03 May 2023 14:18:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5sPpvNmZ/espB1SNspvPfcTp0UcrnUNxDv2ANJOo51gLlboXnP1v3atONpN+J5AgQy2mAsCg==
X-Received: by 2002:a05:622a:1824:b0:3eb:143a:746a with SMTP id t36-20020a05622a182400b003eb143a746amr12936196qtc.4.1683148697540;
        Wed, 03 May 2023 14:18:17 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id z26-20020ac87cba000000b003eb136bec50sm11737859qtv.66.2023.05.03.14.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 14:18:16 -0700 (PDT)
Date: Wed, 3 May 2023 17:18:13 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
	oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFLPlRReglM/Vgfu@x1n>
References: <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="Mh1nfu5EYGrCe8FI"
Content-Disposition: inline

--Mh1nfu5EYGrCe8FI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, May 03, 2023 at 12:45:07PM -0700, Anish Moorthy wrote:
> On Thu, Apr 27, 2023 at 1:26 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Thanks (for doing this test, and also to Nadav for all his inputs), and
> > sorry for a late response.
> 
> No need to apologize: anyways, I've got you comfortably beat on being
> late at this point :)
> 
> > These numbers caught my eye, and I'm very curious why even 2 vcpus can
> > scale that bad.
> >
> > I gave it a shot on a test machine and I got something slightly different:
> >
> >   Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz (20 cores, 40 threads)
> >   $ ./demand_paging_test -b 512M -u MINOR -s shmem -v N
> >   |-------+----------+--------|
> >   | n_thr | per-vcpu | total  |
> >   |-------+----------+--------|
> >   |     1 | 39.5K    | 39.5K  |
> >   |     2 | 33.8K    | 67.6K  |
> >   |     4 | 31.8K    | 127.2K |
> >   |     8 | 30.8K    | 246.1K |
> >   |    16 | 21.9K    | 351.0K |
> >   |-------+----------+--------|
> >
> > I used larger ram due to less cores.  I didn't try 32+ vcpus to make sure I
> > don't have two threads content on a core/thread already since I only got 40
> > hardware threads there, but still we can compare with your lower half.
> >
> > When I was testing I noticed bad numbers and another bug on not using
> > NSEC_PER_SEC properly, so I did this before the test:
> >
> > https://lore.kernel.org/all/20230427201112.2164776-1-peterx@redhat.com/
> >
> > I think it means it still doesn't scale that good, however not so bad
> > either - no obvious 1/2 drop on using 2vcpus.  There're still a bunch of
> > paths triggered in the test so I also don't expect it to fully scale
> > linearly.  From my numbers I just didn't see as drastic as yours. I'm not
> > sure whether it's simply broken test number, parameter differences
> > (e.g. you used 64M only per-vcpu), or hardware differences.
> 
> Hmm, I suspect we're dealing with  hardware differences here. I
> rebased my changes onto those two patches you sent up, taking care not
> to clobber them, but even with the repro command you provided my
> results look very different than yours (at least on 1-4 vcpus) on the
> machine I've been testing on (4x AMD EPYC 7B13 64-Core, 2.2GHz).
> 
> (n=20)
> n_thr      per_vcpu       total
> 1            154K              154K
> 2             92k                184K
> 4             71K                285K
> 8             36K                291K
> 16           19K                310K
> 
> Out of interested I tested on another machine (Intel(R) Xeon(R)
> Platinum 8273CL CPU @ 2.20GHz) as well, and results are a bit
> different again
> 
> (n=20)
> n_thr      per_vcpu       total
> 1            115K              115K
> 2             103k              206K
> 4             65K                262K
> 8             39K                319K
> 16           19K                398K

Interesting.

> 
> It is interesting how all three sets of numbers start off different
> but seem to converge around 16 vCPUs. I did check to make sure the
> memory fault exits sped things up in all cases, and that at least
> stays true.
> 
> By the way, I've got a little helper script that I've been using to
> run/average the selftest results (which can vary quite a bit). I've
> attached it below- hopefully it doesn't bounce from the mailing list.
> Just for reference, the invocation to test the command you provided is
> 
> > python dp_runner.py --num_runs 20 --max_cores 16 --percpu_mem 512M

I found that indeed I shouldn't have stopped at 16 vcpus since that's
exactly where it starts to bottleneck. :)

So out of my curiosity I tried to profile 32 vcpus case on my system with
this test case, meanwhile I tried it both with:

  - 1 uffd + 8 readers
  - 32 uffds (so 32 readers)

I've got the flamegraphs attached for both.

It seems that when using >1 uffds the bottleneck is not the spinlock
anymore but something else.

From what I got there, vmx_vcpu_load() gets more highlights than the
spinlocks. I think that's the tlb flush broadcast.

While OTOH indeed when using 1 uffd we can see obviously the overhead of
spinlock contention on either the fault() path or read()/poll() as you and
James rightfully pointed out.

I'm not sure whether my number is caused by special setup, though. After
all I only had 40 threads and I started 32 vcpus + 8 readers and there'll
be contention already between the workloads.

IMHO this means that there's still chance to provide a more generic
userfaultfd scaling solution as long as we can remove the single spinlock
contention on the fault/fault_pending queues.  I'll see whether I can still
explore a bit on the possibility of this and keep you guys updated.  The
general idea here to me is still to make multi-queue out of 1 uffd.

I _think_ this might also be a positive result to your work, because if the
bottleneck is not userfaultfd (as we scale it with creating multiple;
ignoring the split vma effect), then it cannot be resolved by scaling
userfaultfd alone anyway, anymore.  So a general solution, even if existed,
may not work here for kvm, because we'll get stuck somewhere else already.

-- 
Peter Xu

--Mh1nfu5EYGrCe8FI
Content-Type: image/svg+xml
Content-Disposition: attachment; filename="uffd-1-reader-8.svg"
Content-Transfer-Encoding: quoted-printable

<?xml version=3D"1.0" standalone=3D"no"?>=0A<!DOCTYPE svg PUBLIC "-//W3C//D=
TD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">=0A<svg =
version=3D"1.1" width=3D"1200" height=3D"2134" onload=3D"init(evt)" viewBox=
=3D"0 0 1200 2134" xmlns=3D"http://www.w3.org/2000/svg" xmlns:xlink=3D"http=
://www.w3.org/1999/xlink">=0A<!-- Flame graph stack visualization. See http=
s://github.com/brendangregg/FlameGraph for latest version, and http://www.b=
rendangregg.com/flamegraphs.html for examples. -->=0A<!-- NOTES:  -->=0A<de=
fs>=0A=09<linearGradient id=3D"background" y1=3D"0" y2=3D"1" x1=3D"0" x2=3D=
"0" >=0A=09=09<stop stop-color=3D"#eeeeee" offset=3D"5%" />=0A=09=09<stop s=
top-color=3D"#eeeeb0" offset=3D"95%" />=0A=09</linearGradient>=0A</defs>=0A=
<style type=3D"text/css">=0A=09text { font-family:Verdana; font-size:12px; =
fill:rgb(0,0,0); }=0A=09#search, #ignorecase { opacity:0.1; cursor:pointer;=
 }=0A=09#search:hover, #search.show, #ignorecase:hover, #ignorecase.show { =
opacity:1; }=0A=09#subtitle { text-anchor:middle; font-color:rgb(160,160,16=
0); }=0A=09#title { text-anchor:middle; font-size:17px}=0A=09#unzoom { curs=
or:pointer; }=0A=09#frames > *:hover { stroke:black; stroke-width:0.5; curs=
or:pointer; }=0A=09.hide { display:none; }=0A=09.parent { opacity:0.5; }=0A=
</style>=0A<script type=3D"text/ecmascript">=0A<![CDATA[=0A=09"use strict";=
=0A=09var details, searchbtn, unzoombtn, matchedtxt, svg, searching, curren=
tSearchTerm, ignorecase, ignorecaseBtn;=0A=09function init(evt) {=0A=09=09d=
etails =3D document.getElementById("details").firstChild;=0A=09=09searchbtn=
 =3D document.getElementById("search");=0A=09=09ignorecaseBtn =3D document.=
getElementById("ignorecase");=0A=09=09unzoombtn =3D document.getElementById=
("unzoom");=0A=09=09matchedtxt =3D document.getElementById("matched");=0A=
=09=09svg =3D document.getElementsByTagName("svg")[0];=0A=09=09searching =
=3D 0;=0A=09=09currentSearchTerm =3D null;=0A=0A=09=09// use GET parameters=
 to restore a flamegraphs state.=0A=09=09var params =3D get_params();=0A=09=
=09if (params.x && params.y)=0A=09=09=09zoom(find_group(document.querySelec=
tor('[x=3D"' + params.x + '"][y=3D"' + params.y + '"]')));=0A              =
  if (params.s) search(params.s);=0A=09}=0A=0A=09// event listeners=0A=09wi=
ndow.addEventListener("click", function(e) {=0A=09=09var target =3D find_gr=
oup(e.target);=0A=09=09if (target) {=0A=09=09=09if (target.nodeName =3D=3D =
"a") {=0A=09=09=09=09if (e.ctrlKey =3D=3D=3D false) return;=0A=09=09=09=09e=
.preventDefault();=0A=09=09=09}=0A=09=09=09if (target.classList.contains("p=
arent")) unzoom(true);=0A=09=09=09zoom(target);=0A=09=09=09if (!document.qu=
erySelector('.parent')) {=0A=09=09=09=09// we have basically done a clearzo=
om so clear the url=0A=09=09=09=09var params =3D get_params();=0A=09=09=09=
=09if (params.x) delete params.x;=0A=09=09=09=09if (params.y) delete params=
.y;=0A=09=09=09=09history.replaceState(null, null, parse_params(params));=
=0A=09=09=09=09unzoombtn.classList.add("hide");=0A=09=09=09=09return;=0A=09=
=09=09}=0A=0A=09=09=09// set parameters for zoom state=0A=09=09=09var el =
=3D target.querySelector("rect");=0A=09=09=09if (el && el.attributes && el.=
attributes.y && el.attributes._orig_x) {=0A=09=09=09=09var params =3D get_p=
arams()=0A=09=09=09=09params.x =3D el.attributes._orig_x.value;=0A=09=09=09=
=09params.y =3D el.attributes.y.value;=0A=09=09=09=09history.replaceState(n=
ull, null, parse_params(params));=0A=09=09=09}=0A=09=09}=0A=09=09else if (e=
.target.id =3D=3D "unzoom") clearzoom();=0A=09=09else if (e.target.id =3D=
=3D "search") search_prompt();=0A=09=09else if (e.target.id =3D=3D "ignorec=
ase") toggle_ignorecase();=0A=09}, false)=0A=0A=09// mouse-over for info=0A=
=09// show=0A=09window.addEventListener("mouseover", function(e) {=0A=09=09=
var target =3D find_group(e.target);=0A=09=09if (target) details.nodeValue =
=3D "Function: " + g_to_text(target);=0A=09}, false)=0A=0A=09// clear=0A=09=
window.addEventListener("mouseout", function(e) {=0A=09=09var target =3D fi=
nd_group(e.target);=0A=09=09if (target) details.nodeValue =3D ' ';=0A=09}, =
false)=0A=0A=09// ctrl-F for search=0A=09// ctrl-I to toggle case-sensitive=
 search=0A=09window.addEventListener("keydown",function (e) {=0A=09=09if (e=
.keyCode =3D=3D=3D 114 || (e.ctrlKey && e.keyCode =3D=3D=3D 70)) {=0A=09=09=
=09e.preventDefault();=0A=09=09=09search_prompt();=0A=09=09}=0A=09=09else i=
f (e.ctrlKey && e.keyCode =3D=3D=3D 73) {=0A=09=09=09e.preventDefault();=0A=
=09=09=09toggle_ignorecase();=0A=09=09}=0A=09}, false)=0A=0A=09// functions=
=0A=09function get_params() {=0A=09=09var params =3D {};=0A=09=09var params=
arr =3D window.location.search.substr(1).split('&');=0A=09=09for (var i =3D=
 0; i < paramsarr.length; ++i) {=0A=09=09=09var tmp =3D paramsarr[i].split(=
"=3D");=0A=09=09=09if (!tmp[0] || !tmp[1]) continue;=0A=09=09=09params[tmp[=
0]]  =3D decodeURIComponent(tmp[1]);=0A=09=09}=0A=09=09return params;=0A=09=
}=0A=09function parse_params(params) {=0A=09=09var uri =3D "?";=0A=09=09for=
 (var key in params) {=0A=09=09=09uri +=3D key + '=3D' + encodeURIComponent=
(params[key]) + '&';=0A=09=09}=0A=09=09if (uri.slice(-1) =3D=3D "&")=0A=09=
=09=09uri =3D uri.substring(0, uri.length - 1);=0A=09=09if (uri =3D=3D '?')=
=0A=09=09=09uri =3D window.location.href.split('?')[0];=0A=09=09return uri;=
=0A=09}=0A=09function find_child(node, selector) {=0A=09=09var children =3D=
 node.querySelectorAll(selector);=0A=09=09if (children.length) return child=
ren[0];=0A=09}=0A=09function find_group(node) {=0A=09=09var parent =3D node=
.parentElement;=0A=09=09if (!parent) return;=0A=09=09if (parent.id =3D=3D "=
frames") return node;=0A=09=09return find_group(parent);=0A=09}=0A=09functi=
on orig_save(e, attr, val) {=0A=09=09if (e.attributes["_orig_" + attr] !=3D=
 undefined) return;=0A=09=09if (e.attributes[attr] =3D=3D undefined) return=
;=0A=09=09if (val =3D=3D undefined) val =3D e.attributes[attr].value;=0A=09=
=09e.setAttribute("_orig_" + attr, val);=0A=09}=0A=09function orig_load(e, =
attr) {=0A=09=09if (e.attributes["_orig_"+attr] =3D=3D undefined) return;=
=0A=09=09e.attributes[attr].value =3D e.attributes["_orig_" + attr].value;=
=0A=09=09e.removeAttribute("_orig_"+attr);=0A=09}=0A=09function g_to_text(e=
) {=0A=09=09var text =3D find_child(e, "title").firstChild.nodeValue;=0A=09=
=09return (text)=0A=09}=0A=09function g_to_func(e) {=0A=09=09var func =3D g=
_to_text(e);=0A=09=09// if there's any manipulation we want to do to the fu=
nction=0A=09=09// name before it's searched, do it here before returning.=
=0A=09=09return (func);=0A=09}=0A=09function update_text(e) {=0A=09=09var r=
 =3D find_child(e, "rect");=0A=09=09var t =3D find_child(e, "text");=0A=09=
=09var w =3D parseFloat(r.attributes.width.value) -3;=0A=09=09var txt =3D f=
ind_child(e, "title").textContent.replace(/\([^(]*\)$/,"");=0A=09=09t.attri=
butes.x.value =3D parseFloat(r.attributes.x.value) + 3;=0A=0A=09=09// Small=
er than this size won't fit anything=0A=09=09if (w < 2 * 12 * 0.59) {=0A=09=
=09=09t.textContent =3D "";=0A=09=09=09return;=0A=09=09}=0A=0A=09=09t.textC=
ontent =3D txt;=0A=09=09var sl =3D t.getSubStringLength(0, txt.length);=0A=
=09=09// check if only whitespace or if we can fit the entire string into w=
idth w=0A=09=09if (/^ *$/.test(txt) || sl < w)=0A=09=09=09return;=0A=0A=09=
=09// this isn't perfect, but gives a good starting point=0A=09=09// and av=
oids calling getSubStringLength too often=0A=09=09var start =3D Math.floor(=
(w/sl) * txt.length);=0A=09=09for (var x =3D start; x > 0; x =3D x-2) {=0A=
=09=09=09if (t.getSubStringLength(0, x + 2) <=3D w) {=0A=09=09=09=09t.textC=
ontent =3D txt.substring(0, x) + "..";=0A=09=09=09=09return;=0A=09=09=09}=
=0A=09=09}=0A=09=09t.textContent =3D "";=0A=09}=0A=0A=09// zoom=0A=09functi=
on zoom_reset(e) {=0A=09=09if (e.attributes !=3D undefined) {=0A=09=09=09or=
ig_load(e, "x");=0A=09=09=09orig_load(e, "width");=0A=09=09}=0A=09=09if (e.=
childNodes =3D=3D undefined) return;=0A=09=09for (var i =3D 0, c =3D e.chil=
dNodes; i < c.length; i++) {=0A=09=09=09zoom_reset(c[i]);=0A=09=09}=0A=09}=
=0A=09function zoom_child(e, x, ratio) {=0A=09=09if (e.attributes !=3D unde=
fined) {=0A=09=09=09if (e.attributes.x !=3D undefined) {=0A=09=09=09=09orig=
_save(e, "x");=0A=09=09=09=09e.attributes.x.value =3D (parseFloat(e.attribu=
tes.x.value) - x - 10) * ratio + 10;=0A=09=09=09=09if (e.tagName =3D=3D "te=
xt")=0A=09=09=09=09=09e.attributes.x.value =3D find_child(e.parentNode, "re=
ct[x]").attributes.x.value + 3;=0A=09=09=09}=0A=09=09=09if (e.attributes.wi=
dth !=3D undefined) {=0A=09=09=09=09orig_save(e, "width");=0A=09=09=09=09e.=
attributes.width.value =3D parseFloat(e.attributes.width.value) * ratio;=0A=
=09=09=09}=0A=09=09}=0A=0A=09=09if (e.childNodes =3D=3D undefined) return;=
=0A=09=09for (var i =3D 0, c =3D e.childNodes; i < c.length; i++) {=0A=09=
=09=09zoom_child(c[i], x - 10, ratio);=0A=09=09}=0A=09}=0A=09function zoom_=
parent(e) {=0A=09=09if (e.attributes) {=0A=09=09=09if (e.attributes.x !=3D =
undefined) {=0A=09=09=09=09orig_save(e, "x");=0A=09=09=09=09e.attributes.x.=
value =3D 10;=0A=09=09=09}=0A=09=09=09if (e.attributes.width !=3D undefined=
) {=0A=09=09=09=09orig_save(e, "width");=0A=09=09=09=09e.attributes.width.v=
alue =3D parseInt(svg.width.baseVal.value) - (10 * 2);=0A=09=09=09}=0A=09=
=09}=0A=09=09if (e.childNodes =3D=3D undefined) return;=0A=09=09for (var i =
=3D 0, c =3D e.childNodes; i < c.length; i++) {=0A=09=09=09zoom_parent(c[i]=
);=0A=09=09}=0A=09}=0A=09function zoom(node) {=0A=09=09var attr =3D find_ch=
ild(node, "rect").attributes;=0A=09=09var width =3D parseFloat(attr.width.v=
alue);=0A=09=09var xmin =3D parseFloat(attr.x.value);=0A=09=09var xmax =3D =
parseFloat(xmin + width);=0A=09=09var ymin =3D parseFloat(attr.y.value);=0A=
=09=09var ratio =3D (svg.width.baseVal.value - 2 * 10) / width;=0A=0A=09=09=
// XXX: Workaround for JavaScript float issues (fix me)=0A=09=09var fudge =
=3D 0.0001;=0A=0A=09=09unzoombtn.classList.remove("hide");=0A=0A=09=09var e=
l =3D document.getElementById("frames").children;=0A=09=09for (var i =3D 0;=
 i < el.length; i++) {=0A=09=09=09var e =3D el[i];=0A=09=09=09var a =3D fin=
d_child(e, "rect").attributes;=0A=09=09=09var ex =3D parseFloat(a.x.value);=
=0A=09=09=09var ew =3D parseFloat(a.width.value);=0A=09=09=09var upstack;=
=0A=09=09=09// Is it an ancestor=0A=09=09=09if (0 =3D=3D 0) {=0A=09=09=09=
=09upstack =3D parseFloat(a.y.value) > ymin;=0A=09=09=09} else {=0A=09=09=
=09=09upstack =3D parseFloat(a.y.value) < ymin;=0A=09=09=09}=0A=09=09=09if =
(upstack) {=0A=09=09=09=09// Direct ancestor=0A=09=09=09=09if (ex <=3D xmin=
 && (ex+ew+fudge) >=3D xmax) {=0A=09=09=09=09=09e.classList.add("parent");=
=0A=09=09=09=09=09zoom_parent(e);=0A=09=09=09=09=09update_text(e);=0A=09=09=
=09=09}=0A=09=09=09=09// not in current path=0A=09=09=09=09else=0A=09=09=09=
=09=09e.classList.add("hide");=0A=09=09=09}=0A=09=09=09// Children maybe=0A=
=09=09=09else {=0A=09=09=09=09// no common path=0A=09=09=09=09if (ex < xmin=
 || ex + fudge >=3D xmax) {=0A=09=09=09=09=09e.classList.add("hide");=0A=09=
=09=09=09}=0A=09=09=09=09else {=0A=09=09=09=09=09zoom_child(e, xmin, ratio)=
;=0A=09=09=09=09=09update_text(e);=0A=09=09=09=09}=0A=09=09=09}=0A=09=09}=
=0A=09=09search();=0A=09}=0A=09function unzoom(dont_update_text) {=0A=09=09=
unzoombtn.classList.add("hide");=0A=09=09var el =3D document.getElementById=
("frames").children;=0A=09=09for(var i =3D 0; i < el.length; i++) {=0A=09=
=09=09el[i].classList.remove("parent");=0A=09=09=09el[i].classList.remove("=
hide");=0A=09=09=09zoom_reset(el[i]);=0A=09=09=09if(!dont_update_text) upda=
te_text(el[i]);=0A=09=09}=0A=09=09search();=0A=09}=0A=09function clearzoom(=
) {=0A=09=09unzoom();=0A=0A=09=09// remove zoom state=0A=09=09var params =
=3D get_params();=0A=09=09if (params.x) delete params.x;=0A=09=09if (params=
.y) delete params.y;=0A=09=09history.replaceState(null, null, parse_params(=
params));=0A=09}=0A=0A=09// search=0A=09function toggle_ignorecase() {=0A=
=09=09ignorecase =3D !ignorecase;=0A=09=09if (ignorecase) {=0A=09=09=09igno=
recaseBtn.classList.add("show");=0A=09=09} else {=0A=09=09=09ignorecaseBtn.=
classList.remove("show");=0A=09=09}=0A=09=09reset_search();=0A=09=09search(=
);=0A=09}=0A=09function reset_search() {=0A=09=09var el =3D document.queryS=
electorAll("#frames rect");=0A=09=09for (var i =3D 0; i < el.length; i++) {=
=0A=09=09=09orig_load(el[i], "fill")=0A=09=09}=0A=09=09var params =3D get_p=
arams();=0A=09=09delete params.s;=0A=09=09history.replaceState(null, null, =
parse_params(params));=0A=09}=0A=09function search_prompt() {=0A=09=09if (!=
searching) {=0A=09=09=09var term =3D prompt("Enter a search term (regexp " =
+=0A=09=09=09    "allowed, eg: ^ext4_)"=0A=09=09=09    + (ignorecase ? ", i=
gnoring case" : "")=0A=09=09=09    + "\nPress Ctrl-i to toggle case sensiti=
vity", "");=0A=09=09=09if (term !=3D null) search(term);=0A=09=09} else {=
=0A=09=09=09reset_search();=0A=09=09=09searching =3D 0;=0A=09=09=09currentS=
earchTerm =3D null;=0A=09=09=09searchbtn.classList.remove("show");=0A=09=09=
=09searchbtn.firstChild.nodeValue =3D "Search"=0A=09=09=09matchedtxt.classL=
ist.add("hide");=0A=09=09=09matchedtxt.firstChild.nodeValue =3D ""=0A=09=09=
}=0A=09}=0A=09function search(term) {=0A=09=09if (term) currentSearchTerm =
=3D term;=0A=0A=09=09var re =3D new RegExp(currentSearchTerm, ignorecase ? =
'i' : '');=0A=09=09var el =3D document.getElementById("frames").children;=
=0A=09=09var matches =3D new Object();=0A=09=09var maxwidth =3D 0;=0A=09=09=
for (var i =3D 0; i < el.length; i++) {=0A=09=09=09var e =3D el[i];=0A=09=
=09=09var func =3D g_to_func(e);=0A=09=09=09var rect =3D find_child(e, "rec=
t");=0A=09=09=09if (func =3D=3D null || rect =3D=3D null)=0A=09=09=09=09con=
tinue;=0A=0A=09=09=09// Save max width. Only works as we have a root frame=
=0A=09=09=09var w =3D parseFloat(rect.attributes.width.value);=0A=09=09=09i=
f (w > maxwidth)=0A=09=09=09=09maxwidth =3D w;=0A=0A=09=09=09if (func.match=
(re)) {=0A=09=09=09=09// highlight=0A=09=09=09=09var x =3D parseFloat(rect.=
attributes.x.value);=0A=09=09=09=09orig_save(rect, "fill");=0A=09=09=09=09r=
ect.attributes.fill.value =3D "rgb(230,0,230)";=0A=0A=09=09=09=09// remembe=
r matches=0A=09=09=09=09if (matches[x] =3D=3D undefined) {=0A=09=09=09=09=
=09matches[x] =3D w;=0A=09=09=09=09} else {=0A=09=09=09=09=09if (w > matche=
s[x]) {=0A=09=09=09=09=09=09// overwrite with parent=0A=09=09=09=09=09=09ma=
tches[x] =3D w;=0A=09=09=09=09=09}=0A=09=09=09=09}=0A=09=09=09=09searching =
=3D 1;=0A=09=09=09}=0A=09=09}=0A=09=09if (!searching)=0A=09=09=09return;=0A=
=09=09var params =3D get_params();=0A=09=09params.s =3D currentSearchTerm;=
=0A=09=09history.replaceState(null, null, parse_params(params));=0A=0A=09=
=09searchbtn.classList.add("show");=0A=09=09searchbtn.firstChild.nodeValue =
=3D "Reset Search";=0A=0A=09=09// calculate percent matched, excluding vert=
ical overlap=0A=09=09var count =3D 0;=0A=09=09var lastx =3D -1;=0A=09=09var=
 lastw =3D 0;=0A=09=09var keys =3D Array();=0A=09=09for (k in matches) {=0A=
=09=09=09if (matches.hasOwnProperty(k))=0A=09=09=09=09keys.push(k);=0A=09=
=09}=0A=09=09// sort the matched frames by their x location=0A=09=09// asce=
nding, then width descending=0A=09=09keys.sort(function(a, b){=0A=09=09=09r=
eturn a - b;=0A=09=09});=0A=09=09// Step through frames saving only the big=
gest bottom-up frames=0A=09=09// thanks to the sort order. This relies on t=
he tree property=0A=09=09// where children are always smaller than their pa=
rents.=0A=09=09var fudge =3D 0.0001;=09// JavaScript floating point=0A=09=
=09for (var k in keys) {=0A=09=09=09var x =3D parseFloat(keys[k]);=0A=09=09=
=09var w =3D matches[keys[k]];=0A=09=09=09if (x >=3D lastx + lastw - fudge)=
 {=0A=09=09=09=09count +=3D w;=0A=09=09=09=09lastx =3D x;=0A=09=09=09=09las=
tw =3D w;=0A=09=09=09}=0A=09=09}=0A=09=09// display matched percent=0A=09=
=09matchedtxt.classList.remove("hide");=0A=09=09var pct =3D 100 * count / m=
axwidth;=0A=09=09if (pct !=3D 100) pct =3D pct.toFixed(1)=0A=09=09matchedtx=
t.firstChild.nodeValue =3D "Matched: " + pct + "%";=0A=09}=0A]]>=0A</script=
>=0A<rect x=3D"0.0" y=3D"0" width=3D"1200.0" height=3D"2134.0" fill=3D"url(=
#background)"  />=0A<text id=3D"title" x=3D"600.00" y=3D"24" >Flame Graph</=
text>=0A<text id=3D"details" x=3D"10.00" y=3D"2117" > </text>=0A<text id=3D=
"unzoom" x=3D"10.00" y=3D"24" class=3D"hide">Reset Zoom</text>=0A<text id=
=3D"search" x=3D"1090.00" y=3D"24" >Search</text>=0A<text id=3D"ignorecase"=
 x=3D"1174.00" y=3D"24" >ic</text>=0A<text id=3D"matched" x=3D"1090.00" y=
=3D"2117" > </text>=0A<g id=3D"frames">=0A<g >=0A<title>get_user_pages_unlo=
cked (1,454,404,838 samples, 0.39%)</title><rect x=3D"93.8" y=3D"1653" widt=
h=3D"4.6" height=3D"15.0" fill=3D"rgb(223,7,27)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"96.79" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>try_grab_folio=
 (164,415,151 samples, 0.04%)</title><rect x=3D"184.2" y=3D"1797" width=3D"=
0.6" height=3D"15.0" fill=3D"rgb(247,52,23)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"187.23" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (129=
,467,492 samples, 0.03%)</title><rect x=3D"10.4" y=3D"53" width=3D"0.4" hei=
ght=3D"15.0" fill=3D"rgb(226,7,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.3=
9" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (790,301,3=
71 samples, 0.21%)</title><rect x=3D"26.5" y=3D"341" width=3D"2.5" height=
=3D"15.0" fill=3D"rgb(223,6,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" =
y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (74,060,258 samples,=
 0.02%)</title><rect x=3D"58.2" y=3D"1381" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(238,10,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.19" y=3D"1391.5=
" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (711,372,626 sample=
s, 0.19%)</title><rect x=3D"38.6" y=3D"1349" width=3D"2.2" height=3D"15.0" =
fill=3D"rgb(254,68,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.55" y=3D"1359=
.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,167,137,370 samples, =
0.32%)</title><rect x=3D"80.8" y=3D"1733" width=3D"3.7" height=3D"15.0" fil=
l=3D"rgb(223,137,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.75" y=3D"1743.5=
" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (219,093,086 sa=
mples, 0.06%)</title><rect x=3D"782.0" y=3D"1589" width=3D"0.7" height=3D"1=
5.0" fill=3D"rgb(220,81,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=
=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (2,082,407,975 sampl=
es, 0.56%)</title><rect x=3D"59.8" y=3D"1573" width=3D"6.6" height=3D"15.0"=
 fill=3D"rgb(235,160,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.81" y=3D"15=
83.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (219,718,564 samples, 0.=
06%)</title><rect x=3D"49.1" y=3D"1589" width=3D"0.7" height=3D"15.0" fill=
=3D"rgb(242,48,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.05" y=3D"1599.5" =
></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (303,688,203 samples, 0.0=
8%)</title><rect x=3D"812.7" y=3D"1877" width=3D"0.9" height=3D"15.0" fill=
=3D"rgb(249,26,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"815.66" y=3D"1887.5"=
 ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (552,900,486 samples, 0.15%=
)</title><rect x=3D"106.8" y=3D"1717" width=3D"1.8" height=3D"15.0" fill=3D=
"rgb(251,227,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"109.79" y=3D"1727.5" >=
</text>=0A</g>=0A<g >=0A<title>fput (533,273,168 samples, 0.14%)</title><re=
ct x=3D"904.4" y=3D"1957" width=3D"1.7" height=3D"15.0" fill=3D"rgb(231,166=
,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"907.39" y=3D"1967.5" ></text>=0A</g=
>=0A<g >=0A<title>__srcu_read_unlock (126,851,523 samples, 0.03%)</title><r=
ect x=3D"108.6" y=3D"1765" width=3D"0.4" height=3D"15.0" fill=3D"rgb(249,37=
,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.62" y=3D"1775.5" ></text>=0A</g=
>=0A<g >=0A<title>[kvm-intel.ko] (606,119,248 samples, 0.16%)</title><rect =
x=3D"140.3" y=3D"1797" width=3D"2.0" height=3D"15.0" fill=3D"rgb(253,206,33=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"143.34" y=3D"1807.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_release_page_clean (4,343,475,753 samples, 1.17%)</tit=
le><rect x=3D"794.5" y=3D"1893" width=3D"13.9" height=3D"15.0" fill=3D"rgb(=
210,75,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.54" y=3D"1903.5" ></text=
>=0A</g>=0A<g >=0A<title>__get_user_pages (2,131,350,080 samples, 0.58%)</t=
itle><rect x=3D"112.9" y=3D"1685" width=3D"6.7" height=3D"15.0" fill=3D"rgb=
(248,130,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1695.5" ></te=
xt>=0A</g>=0A<g >=0A<title>update_rq_clock (282,341,787 samples, 0.08%)</ti=
tle><rect x=3D"71.4" y=3D"1397" width=3D"0.9" height=3D"15.0" fill=3D"rgb(2=
09,205,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"74.36" y=3D"1407.5" ></text>=
=0A</g>=0A<g >=0A<title>__mod_memcg_lruvec_state (155,154,982 samples, 0.04=
%)</title><rect x=3D"1188.4" y=3D"1813" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(226,173,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.35" y=3D"1823.=
5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (2,131,350,080 samples=
, 0.58%)</title><rect x=3D"112.9" y=3D"1653" width=3D"6.7" height=3D"15.0" =
fill=3D"rgb(211,1,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1663=
.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (194,284,188 samples, =
0.05%)</title><rect x=3D"111.3" y=3D"1445" width=3D"0.6" height=3D"15.0" fi=
ll=3D"rgb(246,161,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.26" y=3D"1455=
.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (2,491,551,090 samples,=
 0.67%)</title><rect x=3D"17.2" y=3D"261" width=3D"8.0" height=3D"15.0" fil=
l=3D"rgb(237,77,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"271.5" =
></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (61,757,117 samples=
, 0.02%)</title><rect x=3D"29.0" y=3D"293" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(241,175,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"303.5=
" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (269,433,971 =
samples, 0.07%)</title><rect x=3D"262.3" y=3D"1941" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(228,205,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31" =
y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,236,031,3=
54 samples, 0.33%)</title><rect x=3D"88.4" y=3D"1589" width=3D"3.9" height=
=3D"15.0" fill=3D"rgb(232,137,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36=
" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>_raw_read_unlock (518,952,22=
1 samples, 0.14%)</title><rect x=3D"463.1" y=3D"1893" width=3D"1.6" height=
=3D"15.0" fill=3D"rgb(205,46,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"466.05=
" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (1=
32,976,269 samples, 0.04%)</title><rect x=3D"1032.5" y=3D"1845" width=3D"0.=
4" height=3D"15.0" fill=3D"rgb(206,77,0)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1035.50" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>update_process_ti=
mes (219,093,086 samples, 0.06%)</title><rect x=3D"782.0" y=3D"1573" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(215,60,31)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"784.97" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (12=
,478,038,127 samples, 3.37%)</title><rect x=3D"10.0" y=3D"1717" width=3D"39=
.8" height=3D"15.0" fill=3D"rgb(247,170,32)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"13.00" y=3D"1727.5" >[un..</text>=0A</g>=0A<g >=0A<title>xas_start (45=
2,397,190 samples, 0.12%)</title><rect x=3D"509.3" y=3D"1701" width=3D"1.5"=
 height=3D"15.0" fill=3D"rgb(218,216,25)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"512.34" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irq=
 (66,487,499 samples, 0.02%)</title><rect x=3D"273.2" y=3D"1941" width=3D"0=
.2" height=3D"15.0" fill=3D"rgb(231,7,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"276.20" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (=
90,095,623 samples, 0.02%)</title><rect x=3D"273.4" y=3D"1941" width=3D"0.3=
" height=3D"15.0" fill=3D"rgb(239,8,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"276.42" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (2,549,=
679,159 samples, 0.69%)</title><rect x=3D"59.8" y=3D"1717" width=3D"8.1" he=
ight=3D"15.0" fill=3D"rgb(229,143,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"6=
2.80" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (2,491,=
551,090 samples, 0.67%)</title><rect x=3D"17.2" y=3D"101" width=3D"8.0" hei=
ght=3D"15.0" fill=3D"rgb(209,222,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20=
.24" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>folio_batch_move_lru (196,=
324,174 samples, 0.05%)</title><rect x=3D"73.1" y=3D"1557" width=3D"0.6" he=
ight=3D"15.0" fill=3D"rgb(225,44,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"76=
.06" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (264,013,=
792 samples, 0.07%)</title><rect x=3D"25.6" y=3D"229" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(215,54,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64"=
 y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (104,991,582 sa=
mples, 0.03%)</title><rect x=3D"147.2" y=3D"1813" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(232,60,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.21" y=
=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (1,590,623,571 sa=
mples, 0.43%)</title><rect x=3D"54.0" y=3D"1701" width=3D"5.1" height=3D"15=
.0" fill=3D"rgb(247,205,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=3D=
"1711.5" ></text>=0A</g>=0A<g >=0A<title>check_vma_flags (44,492,216 sample=
s, 0.01%)</title><rect x=3D"484.1" y=3D"1829" width=3D"0.1" height=3D"15.0"=
 fill=3D"rgb(240,151,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"487.08" y=3D"1=
839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (3,063,052,5=
76 samples, 0.83%)</title><rect x=3D"132.5" y=3D"1861" width=3D"9.8" height=
=3D"15.0" fill=3D"rgb(229,188,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.5=
2" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,031,125=
,820 samples, 0.28%)</title><rect x=3D"50.5" y=3D"1397" width=3D"3.2" heigh=
t=3D"15.0" fill=3D"rgb(222,158,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.4=
6" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slo=
wpath (44,783,792,423 samples, 12.09%)</title><rect x=3D"289.0" y=3D"1925" =
width=3D"142.7" height=3D"15.0" fill=3D"rgb(244,173,4)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"292.01" y=3D"1935.5" >native_queued_spin..</text>=0A</g>=0A=
<g >=0A<title>_raw_spin_lock_irqsave (480,369,154 samples, 0.13%)</title><r=
ect x=3D"129.0" y=3D"1573" width=3D"1.5" height=3D"15.0" fill=3D"rgb(214,21=
9,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.96" y=3D"1583.5" ></text>=0A<=
/g>=0A<g >=0A<title>shmem_fault (1,134,844,315 samples, 0.31%)</title><rect=
 x=3D"143.4" y=3D"1669" width=3D"3.6" height=3D"15.0" fill=3D"rgb(209,182,8=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"146.37" y=3D"1679.5" ></text>=0A</g>=
=0A<g >=0A<title>syscall_exit_to_user_mode (476,007,380 samples, 0.13%)</ti=
tle><rect x=3D"1170.6" y=3D"2005" width=3D"1.5" height=3D"15.0" fill=3D"rgb=
(225,181,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.63" y=3D"2015.5" ></t=
ext>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title=
><rect x=3D"10.0" y=3D"1653" width=3D"19.2" height=3D"15.0" fill=3D"rgb(229=
,94,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1663.5" ></text>=0A=
</g>=0A<g >=0A<title>fput (1,917,166,190 samples, 0.52%)</title><rect x=3D"=
257.1" y=3D"1973" width=3D"6.1" height=3D"15.0" fill=3D"rgb(209,34,24)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"260.06" y=3D"1983.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_tdp_page_fault (115,732,797,858 samples, 31.25%)</title><rec=
t x=3D"461.5" y=3D"1909" width=3D"368.7" height=3D"15.0" fill=3D"rgb(219,16=
7,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"464.54" y=3D"1919.5" >kvm_tdp_pag=
e_fault</text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (120=
,113,565 samples, 0.03%)</title><rect x=3D"138.0" y=3D"1589" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(208,4,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
40.96" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>try_to_wake_up (35,932,=
356 samples, 0.01%)</title><rect x=3D"94.7" y=3D"1461" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(214,59,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"97.72"=
 y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (1,35=
6,735,820 samples, 0.37%)</title><rect x=3D"128.2" y=3D"1845" width=3D"4.3"=
 height=3D"15.0" fill=3D"rgb(241,141,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"131.19" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioct=
l_run (1,688,676,626 samples, 0.46%)</title><rect x=3D"32.2" y=3D"1589" wid=
th=3D"5.4" height=3D"15.0" fill=3D"rgb(218,64,1)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"35.23" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>native_queued=
_spin_lock_slowpath (37,712,569,412 samples, 10.18%)</title><rect x=3D"910.=
0" y=3D"1909" width=3D"120.1" height=3D"15.0" fill=3D"rgb(210,141,33)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"913.00" y=3D"1919.5" >native_queued_..</te=
xt>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (1,200,111,144 samples, 0=
.32%)</title><rect x=3D"122.7" y=3D"1557" width=3D"3.8" height=3D"15.0" fil=
l=3D"rgb(227,20,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.70" y=3D"1567.5"=
 ></text>=0A</g>=0A<g >=0A<title>internal_get_user_pages_fast (3,908,985,78=
6 samples, 1.06%)</title><rect x=3D"470.3" y=3D"1845" width=3D"12.4" height=
=3D"15.0" fill=3D"rgb(226,161,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"473.2=
7" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (2,628,043,552 s=
amples, 0.71%)</title><rect x=3D"158.3" y=3D"1813" width=3D"8.4" height=3D"=
15.0" fill=3D"rgb(225,212,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.30" y=
=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (2,423,604,255 samp=
les, 0.65%)</title><rect x=3D"132.6" y=3D"1653" width=3D"7.7" height=3D"15.=
0" fill=3D"rgb(254,86,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"=
1663.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (1,896,941,6=
08 samples, 0.51%)</title><rect x=3D"113.3" y=3D"1541" width=3D"6.1" height=
=3D"15.0" fill=3D"rgb(207,210,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"116.3=
5" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (219,093,=
086 samples, 0.06%)</title><rect x=3D"782.0" y=3D"1637" width=3D"0.7" heigh=
t=3D"15.0" fill=3D"rgb(221,140,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.=
97" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>tlb_flush_mmu (133,380,601=
 samples, 0.04%)</title><rect x=3D"1187.2" y=3D"1877" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(237,49,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.2=
2" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>schedule (44,076,692 sample=
s, 0.01%)</title><rect x=3D"178.7" y=3D"1685" width=3D"0.1" height=3D"15.0"=
 fill=3D"rgb(215,84,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"181.65" y=3D"16=
95.5" ></text>=0A</g>=0A<g >=0A<title>try_to_wake_up (2,944,284,327 samples=
, 0.79%)</title><rect x=3D"215.0" y=3D"1893" width=3D"9.4" height=3D"15.0" =
fill=3D"rgb(227,41,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"218.01" y=3D"190=
3.5" ></text>=0A</g>=0A<g >=0A<title>tdp_mmu_zap_leafs (41,394,896 samples,=
 0.01%)</title><rect x=3D"875.4" y=3D"1813" width=3D"0.1" height=3D"15.0" f=
ill=3D"rgb(224,142,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"878.39" y=3D"182=
3.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (2,433,229,386 samples=
, 0.66%)</title><rect x=3D"132.6" y=3D"1829" width=3D"7.7" height=3D"15.0" =
fill=3D"rgb(249,69,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"183=
9.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_state (110,820,225 sample=
s, 0.03%)</title><rect x=3D"1188.0" y=3D"1813" width=3D"0.4" height=3D"15.0=
" fill=3D"rgb(213,22,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.00" y=3D"=
1823.5" ></text>=0A</g>=0A<g >=0A<title>vfs_read (52,893,193,349 samples, 1=
4.28%)</title><rect x=3D"263.2" y=3D"1973" width=3D"168.5" height=3D"15.0" =
fill=3D"rgb(239,145,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"266.17" y=3D"19=
83.5" >vfs_read</text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (67,112,045 =
samples, 0.02%)</title><rect x=3D"111.9" y=3D"1541" width=3D"0.2" height=3D=
"15.0" fill=3D"rgb(244,104,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.88" y=
=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (133,196,037,3=
96 samples, 35.96%)</title><rect x=3D"451.0" y=3D"1957" width=3D"424.4" hei=
ght=3D"15.0" fill=3D"rgb(248,25,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"454.=
03" y=3D"1967.5" >vcpu_enter_guest</text>=0A</g>=0A<g >=0A<title>entry_SYSC=
ALL_64 (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"421" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(235,58,54)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"28.18" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (8=
5,570,248 samples, 0.02%)</title><rect x=3D"172.1" y=3D"1893" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(215,107,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"175.13" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (62,8=
48,636 samples, 0.02%)</title><rect x=3D"128.0" y=3D"1797" width=3D"0.2" he=
ight=3D"15.0" fill=3D"rgb(213,171,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
30.99" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (=
1,235,106,116 samples, 0.33%)</title><rect x=3D"185.8" y=3D"1701" width=3D"=
3.9" height=3D"15.0" fill=3D"rgb(206,223,28)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"188.79" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040=
,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1333" width=3D"19.2" =
height=3D"15.0" fill=3D"rgb(250,94,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
13.00" y=3D"1343.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,09=
9 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1173" width=3D"19.2" height=
=3D"15.0" fill=3D"rgb(207,18,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00"=
 y=3D"1183.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (31,529,227 s=
amples, 0.01%)</title><rect x=3D"769.0" y=3D"1653" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(241,105,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"771.99" y=
=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 sample=
s, 1.63%)</title><rect x=3D"10.0" y=3D"1445" width=3D"19.2" height=3D"15.0"=
 fill=3D"rgb(241,41,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"145=
5.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (948,421,280 samples, 0.26=
%)</title><rect x=3D"81.1" y=3D"1509" width=3D"3.0" height=3D"15.0" fill=3D=
"rgb(251,206,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.08" y=3D"1519.5" ></=
text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (159,609,926 samples, 0.04%)=
</title><rect x=3D"77.4" y=3D"1413" width=3D"0.5" height=3D"15.0" fill=3D"r=
gb(235,22,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80.39" y=3D"1423.5" ></te=
xt>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (598,440,106 samples, 0.1=
6%)</title><rect x=3D"224.4" y=3D"1925" width=3D"1.9" height=3D"15.0" fill=
=3D"rgb(245,125,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"227.39" y=3D"1935.5=
" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (85,570,248 samples, 0.02%=
)</title><rect x=3D"172.1" y=3D"1861" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(240,82,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.13" y=3D"1871.5" ><=
/text>=0A</g>=0A<g >=0A<title>handle_userfault (1,026,979,445 samples, 0.28=
%)</title><rect x=3D"84.6" y=3D"1493" width=3D"3.3" height=3D"15.0" fill=3D=
"rgb(234,138,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1503.5" ><=
/text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (2,913,335,273 sample=
s, 0.79%)</title><rect x=3D"158.2" y=3D"1909" width=3D"9.3" height=3D"15.0"=
 fill=3D"rgb(208,118,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.22" y=3D"19=
19.5" ></text>=0A</g>=0A<g >=0A<title>newidle_balance (757,559,301 samples,=
 0.20%)</title><rect x=3D"767.9" y=3D"1669" width=3D"2.4" height=3D"15.0" f=
ill=3D"rgb(241,73,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"770.90" y=3D"1679=
.5" ></text>=0A</g>=0A<g >=0A<title>find_extend_vma (59,449,801 samples, 0.=
02%)</title><rect x=3D"12.5" y=3D"69" width=3D"0.2" height=3D"15.0" fill=3D=
"rgb(236,88,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"79.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__GI___ioctl (2,491,551,090 samples, 0.67%)</tit=
le><rect x=3D"17.2" y=3D"421" width=3D"8.0" height=3D"15.0" fill=3D"rgb(249=
,73,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"431.5" ></text>=0A<=
/g>=0A<g >=0A<title>__schedule (67,660,795 samples, 0.02%)</title><rect x=
=3D"17.0" y=3D"53" width=3D"0.2" height=3D"15.0" fill=3D"rgb(225,140,15)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"20.02" y=3D"63.5" ></text>=0A</g>=0A<g >=
=0A<title>shmem_get_folio_gfp (1,523,136,454 samples, 0.41%)</title><rect x=
=3D"122.2" y=3D"1605" width=3D"4.9" height=3D"15.0" fill=3D"rgb(221,87,14)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.22" y=3D"1615.5" ></text>=0A</g>=0A=
<g >=0A<title>psi_group_change (76,183,637 samples, 0.02%)</title><rect x=
=3D"24.9" y=3D"37" width=3D"0.3" height=3D"15.0" fill=3D"rgb(240,95,27)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"27.93" y=3D"47.5" ></text>=0A</g>=0A<g >=
=0A<title>__x64_sys_ioctl (2,305,287,529 samples, 0.62%)</title><rect x=3D"=
42.4" y=3D"1653" width=3D"7.4" height=3D"15.0" fill=3D"rgb(220,69,0)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A=
<title>__handle_mm_fault (264,013,792 samples, 0.07%)</title><rect x=3D"25.=
6" y=3D"213" width=3D"0.9" height=3D"15.0" fill=3D"rgb(220,171,13)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>kvm_tdp_page_fault (1,283,638,963 samples, 0.35%)</title><rect x=3D"49.=
8" y=3D"1573" width=3D"4.1" height=3D"15.0" fill=3D"rgb(215,40,8)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__x64_sys_ioctl (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=
=3D"437" width=3D"0.2" height=3D"15.0" fill=3D"rgb(214,17,31)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"32.00" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>=
__wake_up_common_lock (4,652,782,003 samples, 1.26%)</title><rect x=3D"211.=
7" y=3D"1941" width=3D"14.8" height=3D"15.0" fill=3D"rgb(213,32,5)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"214.69" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<=
title>vcpu_enter_guest (2,913,300,520 samples, 0.79%)</title><rect x=3D"158=
.2" y=3D"1893" width=3D"9.3" height=3D"15.0" fill=3D"rgb(217,117,13)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"161.22" y=3D"1903.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_irqsave (557,657,094 samples, 0.15%)</title><rect =
x=3D"44.2" y=3D"1349" width=3D"1.8" height=3D"15.0" fill=3D"rgb(220,114,39)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"47.23" y=3D"1359.5" ></text>=0A</g>=0A=
<g >=0A<title>[unknown] (751,775,628 samples, 0.20%)</title><rect x=3D"10.0=
" y=3D"261" width=3D"2.4" height=3D"15.0" fill=3D"rgb(221,211,51)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"13.00" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_mmu_page_fault (2,137,312,641 samples, 0.58%)</title><rect x=3D"112.=
9" y=3D"1765" width=3D"6.8" height=3D"15.0" fill=3D"rgb(222,150,38)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A=
<title>__wake_up_common_lock (704,985,880 samples, 0.19%)</title><rect x=3D=
"81.2" y=3D"1461" width=3D"2.2" height=3D"15.0" fill=3D"rgb(225,133,50)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"84.18" y=3D"1471.5" ></text>=0A</g>=0A<g >=
=0A<title>hva_to_pfn (1,110,100,025 samples, 0.30%)</title><rect x=3D"109.1=
" y=3D"1701" width=3D"3.5" height=3D"15.0" fill=3D"rgb(208,219,5)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"112.07" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<t=
itle>get_user_pages_unlocked (2,425,823,890 samples, 0.65%)</title><rect x=
=3D"132.6" y=3D"1749" width=3D"7.7" height=3D"15.0" fill=3D"rgb(225,9,17)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"1759.5" ></text>=0A</g>=0A<=
g >=0A<title>preempt_count_add (37,366,887 samples, 0.01%)</title><rect x=
=3D"790.3" y=3D"1829" width=3D"0.2" height=3D"15.0" fill=3D"rgb(217,26,27)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"793.33" y=3D"1839.5" ></text>=0A</g>=0A=
<g >=0A<title>native_queued_spin_lock_slowpath (557,657,094 samples, 0.15%)=
</title><rect x=3D"44.2" y=3D"1317" width=3D"1.8" height=3D"15.0" fill=3D"r=
gb(235,219,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"47.23" y=3D"1327.5" ></t=
ext>=0A</g>=0A<g >=0A<title>_copy_to_user (110,847,767 samples, 0.03%)</tit=
le><rect x=3D"272.8" y=3D"1941" width=3D"0.3" height=3D"15.0" fill=3D"rgb(2=
33,15,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"275.78" y=3D"1951.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,616,765,146 samples, 0.44%)</titl=
e><rect x=3D"88.2" y=3D"1765" width=3D"5.1" height=3D"15.0" fill=3D"rgb(227=
,145,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.17" y=3D"1775.5" ></text>=
=0A</g>=0A<g >=0A<title>__get_user_pages (983,193,554 samples, 0.27%)</titl=
e><rect x=3D"81.0" y=3D"1589" width=3D"3.1" height=3D"15.0" fill=3D"rgb(246=
,19,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.96" y=3D"1599.5" ></text>=0A=
</g>=0A<g >=0A<title>__do_fault (1,293,336,492 samples, 0.35%)</title><rect=
 x=3D"185.8" y=3D"1765" width=3D"4.1" height=3D"15.0" fill=3D"rgb(253,10,2)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.75" y=3D"1775.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (295,823,689 samples, 0.08%)</title><rect=
 x=3D"84.6" y=3D"1445" width=3D"1.0" height=3D"15.0" fill=3D"rgb(216,151,42=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1455.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (41,720,078,120 samples, 11.26%)</title><=
rect x=3D"1037.6" y=3D"1925" width=3D"132.9" height=3D"15.0" fill=3D"rgb(20=
7,5,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1040.58" y=3D"1935.5" >do_raw_sp=
in_lock</text>=0A</g>=0A<g >=0A<title>irq_exit_rcu (37,283,880 samples, 0.0=
1%)</title><rect x=3D"706.4" y=3D"1669" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(210,43,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.42" y=3D"1679.5"=
 ></text>=0A</g>=0A<g >=0A<title>try_to_wake_up (312,099,913 samples, 0.08%=
)</title><rect x=3D"109.2" y=3D"1493" width=3D"1.0" height=3D"15.0" fill=3D=
"rgb(212,63,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.19" y=3D"1503.5" ><=
/text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (845,221,885 samples, 0=
.23%)</title><rect x=3D"55.2" y=3D"1397" width=3D"2.6" height=3D"15.0" fill=
=3D"rgb(230,99,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"58.16" y=3D"1407.5" =
></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (2,032,317,152 samples, =
0.55%)</title><rect x=3D"172.4" y=3D"1893" width=3D"6.5" height=3D"15.0" fi=
ll=3D"rgb(212,76,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=3D"1903.=
5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (38,277,410,882 samples=
, 10.33%)</title><rect x=3D"908.2" y=3D"1925" width=3D"121.9" height=3D"15.=
0" fill=3D"rgb(217,140,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"911.20" y=3D=
"1935.5" >do_raw_spin_lock</text>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock=
 (367,399,248 samples, 0.10%)</title><rect x=3D"274.8" y=3D"1925" width=3D"=
1.2" height=3D"15.0" fill=3D"rgb(250,78,18)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"277.83" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,=
654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1429" width=3D"19.2" h=
eight=3D"15.0" fill=3D"rgb(212,76,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
.00" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>pollwake (35,932,356 samp=
les, 0.01%)</title><rect x=3D"94.7" y=3D"1477" width=3D"0.1" height=3D"15.0=
" fill=3D"rgb(236,48,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"97.72" y=3D"14=
87.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (47,3=
48,631 samples, 0.01%)</title><rect x=3D"706.7" y=3D"1717" width=3D"0.1" he=
ight=3D"15.0" fill=3D"rgb(232,137,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
09.65" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>xas_load (1,310,216,328=
 samples, 0.35%)</title><rect x=3D"506.6" y=3D"1717" width=3D"4.2" height=
=3D"15.0" fill=3D"rgb(210,116,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"509.6=
1" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (123,051,5=
61 samples, 0.03%)</title><rect x=3D"10.0" y=3D"117" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(247,145,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>in_lock_functions (44,158,303=
 samples, 0.01%)</title><rect x=3D"1182.8" y=3D"1781" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(231,47,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.8=
4" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 sa=
mples, 1.63%)</title><rect x=3D"10.0" y=3D"1109" width=3D"19.2" height=3D"1=
5.0" fill=3D"rgb(235,167,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"1119.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,049,973,543 sampl=
es, 0.28%)</title><rect x=3D"50.4" y=3D"1445" width=3D"3.3" height=3D"15.0"=
 fill=3D"rgb(240,208,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.40" y=3D"14=
55.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (44,351,405 samples, =
0.01%)</title><rect x=3D"902.3" y=3D"1957" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(240,41,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"905.32" y=3D"1967.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (2,312,444,881 sample=
s, 0.62%)</title><rect x=3D"59.8" y=3D"1605" width=3D"7.4" height=3D"15.0" =
fill=3D"rgb(231,33,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.81" y=3D"1615=
.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (129,467,492 samples, =
0.03%)</title><rect x=3D"10.4" y=3D"149" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(250,32,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=3D"159.5" >=
</text>=0A</g>=0A<g >=0A<title>__calc_delta (109,205,179 samples, 0.03%)</t=
itle><rect x=3D"750.7" y=3D"1637" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(205,111,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"753.75" y=3D"1647.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__wake_up_common (5,528,795,322 samples, 1.49%)<=
/title><rect x=3D"194.1" y=3D"1941" width=3D"17.6" height=3D"15.0" fill=3D"=
rgb(227,213,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"197.08" y=3D"1951.5" ><=
/text>=0A</g>=0A<g >=0A<title>workingset_activation (49,126,693 samples, 0.=
01%)</title><rect x=3D"31.5" y=3D"1461" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(250,11,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.54" y=3D"1471.5" =
></text>=0A</g>=0A<g >=0A<title>do_fault (89,240,516,799 samples, 24.09%)</=
title><rect x=3D"499.1" y=3D"1797" width=3D"284.3" height=3D"15.0" fill=3D"=
rgb(237,165,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"502.06" y=3D"1807.5" >d=
o_fault</text>=0A</g>=0A<g >=0A<title>do_fault (1,293,336,492 samples, 0.35=
%)</title><rect x=3D"185.8" y=3D"1781" width=3D"4.1" height=3D"15.0" fill=
=3D"rgb(208,146,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.75" y=3D"1791.5=
" ></text>=0A</g>=0A<g >=0A<title>find_vma (59,449,801 samples, 0.02%)</tit=
le><rect x=3D"12.5" y=3D"53" width=3D"0.2" height=3D"15.0" fill=3D"rgb(251,=
97,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"63.5" ></text>=0A</g=
>=0A<g >=0A<title>__schedule (313,725,446 samples, 0.08%)</title><rect x=3D=
"41.2" y=3D"1333" width=3D"1.0" height=3D"15.0" fill=3D"rgb(252,95,38)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"44.21" y=3D"1343.5" ></text>=0A</g>=0A<g >=
=0A<title>do_raw_spin_lock (164,972,171 samples, 0.04%)</title><rect x=3D"3=
0.9" y=3D"1317" width=3D"0.5" height=3D"15.0" fill=3D"rgb(229,129,50)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"33.88" y=3D"1327.5" ></text>=0A</g>=0A<g >=
=0A<title>[kvm-intel.ko] (55,484,525 samples, 0.01%)</title><rect x=3D"88.0=
" y=3D"1685" width=3D"0.2" height=3D"15.0" fill=3D"rgb(212,137,22)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"90.99" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<t=
itle>native_sched_clock (88,638,790 samples, 0.02%)</title><rect x=3D"223.3=
" y=3D"1845" width=3D"0.2" height=3D"15.0" fill=3D"rgb(237,201,9)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"226.26" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<t=
itle>find_lock_entries (352,272,728 samples, 0.10%)</title><rect x=3D"1177.=
4" y=3D"1845" width=3D"1.1" height=3D"15.0" fill=3D"rgb(247,197,19)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1180.38" y=3D"1855.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_irqsave (526,024,177 samples, 0.14%)</title><rect =
x=3D"94.8" y=3D"1493" width=3D"1.7" height=3D"15.0" fill=3D"rgb(239,187,10)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"97.84" y=3D"1503.5" ></text>=0A</g>=0A=
<g >=0A<title>kvm_tdp_page_fault (2,632,189,638 samples, 0.71%)</title><rec=
t x=3D"158.3" y=3D"1845" width=3D"8.4" height=3D"15.0" fill=3D"rgb(207,215,=
28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.30" y=3D"1855.5" ></text>=0A</g=
>=0A<g >=0A<title>dequeue_task_fair (354,960,434 samples, 0.10%)</title><re=
ct x=3D"170.8" y=3D"1637" width=3D"1.1" height=3D"15.0" fill=3D"rgb(224,31,=
51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"173.79" y=3D"1647.5" ></text>=0A</g=
>=0A<g >=0A<title>_raw_spin_lock_irqsave (380,476,439 samples, 0.10%)</titl=
e><rect x=3D"29.7" y=3D"1301" width=3D"1.2" height=3D"15.0" fill=3D"rgb(230=
,87,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.67" y=3D"1311.5" ></text>=0A=
</g>=0A<g >=0A<title>gup_pgd_range (144,445,061 samples, 0.04%)</title><rec=
t x=3D"68.2" y=3D"1541" width=3D"0.5" height=3D"15.0" fill=3D"rgb(210,189,5=
1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1551.5" ></text>=0A</g>=
=0A<g >=0A<title>do_syscall_64 (61,757,117 samples, 0.02%)</title><rect x=
=3D"29.0" y=3D"453" width=3D"0.2" height=3D"15.0" fill=3D"rgb(214,7,25)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"463.5" ></text>=0A</g>=0A<g >=
=0A<title>__kvm_migrate_timers (34,977,727 samples, 0.01%)</title><rect x=
=3D"454.2" y=3D"1941" width=3D"0.1" height=3D"15.0" fill=3D"rgb(238,43,36)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"457.20" y=3D"1951.5" ></text>=0A</g>=0A=
<g >=0A<title>handle_mm_fault (2,165,906,632 samples, 0.58%)</title><rect x=
=3D"148.6" y=3D"1749" width=3D"6.9" height=3D"15.0" fill=3D"rgb(228,0,12)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"151.58" y=3D"1759.5" ></text>=0A</g>=0A<=
g >=0A<title>_raw_spin_unlock_irqrestore (389,560,084 samples, 0.11%)</titl=
e><rect x=3D"274.8" y=3D"1941" width=3D"1.3" height=3D"15.0" fill=3D"rgb(22=
2,163,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.83" y=3D"1951.5" ></text>=
=0A</g>=0A<g >=0A<title>page_remove_rmap (376,891,628 samples, 0.10%)</titl=
e><rect x=3D"1187.6" y=3D"1845" width=3D"1.2" height=3D"15.0" fill=3D"rgb(2=
08,55,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.64" y=3D"1855.5" ></text=
>=0A</g>=0A<g >=0A<title>syscall_trace_enter.isra.17 (88,655,854 samples, 0=
.02%)</title><rect x=3D"896.0" y=3D"2005" width=3D"0.3" height=3D"15.0" fil=
l=3D"rgb(219,62,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"898.99" y=3D"2015.5=
" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (40,235,889 samples, 0.=
01%)</title><rect x=3D"462.9" y=3D"1877" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(253,138,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"465.93" y=3D"1887.5=
" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)<=
/title><rect x=3D"10.0" y=3D"789" width=3D"19.2" height=3D"15.0" fill=3D"rg=
b(222,131,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"799.5" ></text=
>=0A</g>=0A<g >=0A<title>scheduler_tick (51,159,464 samples, 0.01%)</title>=
<rect x=3D"759.8" y=3D"1541" width=3D"0.2" height=3D"15.0" fill=3D"rgb(220,=
201,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"762.79" y=3D"1551.5" ></text>=
=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,091,339,808 samples, 0.29%)<=
/title><rect x=3D"109.1" y=3D"1573" width=3D"3.5" height=3D"15.0" fill=3D"r=
gb(233,78,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.13" y=3D"1583.5" ></t=
ext>=0A</g>=0A<g >=0A<title>remove_wait_queue (39,053,548,511 samples, 10.5=
4%)</title><rect x=3D"906.1" y=3D"1957" width=3D"124.4" height=3D"15.0" fil=
l=3D"rgb(209,17,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"909.09" y=3D"1967.5"=
 >remove_wait_queue</text>=0A</g>=0A<g >=0A<title>[unknown] (20,113,297,518=
 samples, 5.43%)</title><rect x=3D"10.0" y=3D"1781" width=3D"64.1" height=
=3D"15.0" fill=3D"rgb(219,42,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00"=
 y=3D"1791.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (2,9=
13,335,273 samples, 0.79%)</title><rect x=3D"158.2" y=3D"1941" width=3D"9.3=
" height=3D"15.0" fill=3D"rgb(219,81,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"161.22" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1=
,381,981,405 samples, 0.37%)</title><rect x=3D"93.9" y=3D"1621" width=3D"4.=
4" height=3D"15.0" fill=3D"rgb(252,171,20)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"96.91" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>change_protection (=
132,959,376 samples, 0.04%)</title><rect x=3D"1170.9" y=3D"1925" width=3D"0=
.4" height=3D"15.0" fill=3D"rgb(221,78,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1173.87" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault =
(1,523,136,454 samples, 0.41%)</title><rect x=3D"122.2" y=3D"1589" width=3D=
"4.9" height=3D"15.0" fill=3D"rgb(248,43,44)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"125.22" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest=
 (123,051,561 samples, 0.03%)</title><rect x=3D"10.0" y=3D"37" width=3D"0.4=
" height=3D"15.0" fill=3D"rgb(246,105,28)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,1=
67,219,750 samples, 0.32%)</title><rect x=3D"55.1" y=3D"1413" width=3D"3.7"=
 height=3D"15.0" fill=3D"rgb(240,96,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"58.10" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (606,11=
9,248 samples, 0.16%)</title><rect x=3D"140.3" y=3D"1813" width=3D"2.0" hei=
ght=3D"15.0" fill=3D"rgb(211,169,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14=
3.34" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (59,449,=
801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"133" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(216,187,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50"=
 y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>finish_task_switch (47,129,761=
 samples, 0.01%)</title><rect x=3D"66.2" y=3D"1381" width=3D"0.2" height=3D=
"15.0" fill=3D"rgb(241,19,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"69.23" y=
=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>__count_memcg_events (1,066,013=
,814 samples, 0.29%)</title><rect x=3D"494.7" y=3D"1813" width=3D"3.4" heig=
ht=3D"15.0" fill=3D"rgb(214,94,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"497.=
67" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>update_sd_lb_stats.constpr=
op.137 (160,784,438 samples, 0.04%)</title><rect x=3D"28.1" y=3D"37" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(254,122,53)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"31.14" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to=
_user_mode_prepare (88,648,749 samples, 0.02%)</title><rect x=3D"432.0" y=
=3D"1973" width=3D"0.3" height=3D"15.0" fill=3D"rgb(206,185,24)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"435.03" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<tit=
le>_raw_spin_lock_irqsave (41,808,746,693 samples, 11.29%)</title><rect x=
=3D"1037.4" y=3D"1941" width=3D"133.2" height=3D"15.0" fill=3D"rgb(217,33,4=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1040.43" y=3D"1951.5" >_raw_spin_loc=
k_i..</text>=0A</g>=0A<g >=0A<title>update_process_times (132,976,269 sampl=
es, 0.04%)</title><rect x=3D"1032.5" y=3D"1829" width=3D"0.4" height=3D"15.=
0" fill=3D"rgb(211,123,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.50" y=
=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (230,940,305 sam=
ples, 0.06%)</title><rect x=3D"59.1" y=3D"1733" width=3D"0.7" height=3D"15.=
0" fill=3D"rgb(210,125,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.06" y=3D"=
1743.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (191,048,745 samp=
les, 0.05%)</title><rect x=3D"151.0" y=3D"1557" width=3D"0.7" height=3D"15.=
0" fill=3D"rgb(233,167,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"154.05" y=3D=
"1567.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only (45,294,3=
61 samples, 0.01%)</title><rect x=3D"80.8" y=3D"1605" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(208,156,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.82=
" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,1=
32,255,149 samples, 0.31%)</title><rect x=3D"168.5" y=3D"1813" width=3D"3.6=
" height=3D"15.0" fill=3D"rgb(219,47,48)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"171.47" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>folio_unlock (376,=
786,618 samples, 0.10%)</title><rect x=3D"249.3" y=3D"1941" width=3D"1.2" h=
eight=3D"15.0" fill=3D"rgb(232,226,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
252.30" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (182,037,942 =
samples, 0.05%)</title><rect x=3D"12.7" y=3D"101" width=3D"0.6" height=3D"1=
5.0" fill=3D"rgb(207,61,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D=
"111.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,523,136,454 samples, =
0.41%)</title><rect x=3D"122.2" y=3D"1637" width=3D"4.9" height=3D"15.0" fi=
ll=3D"rgb(219,166,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.22" y=3D"1647.=
5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (51,642=
,378,483 samples, 13.94%)</title><rect x=3D"539.8" y=3D"1669" width=3D"164.=
5" height=3D"15.0" fill=3D"rgb(211,111,46)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"542.76" y=3D"1679.5" >native_queued_spin_lo..</text>=0A</g>=0A<g >=0A<t=
itle>do_syscall_64 (1,657,361,967 samples, 0.45%)</title><rect x=3D"93.4" y=
=3D"1813" width=3D"5.3" height=3D"15.0" fill=3D"rgb(240,127,15)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"96.39" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__audit_syscall_entry (44,335,236 samples, 0.01%)</title><rect x=3D"896.1=
" y=3D"1989" width=3D"0.2" height=3D"15.0" fill=3D"rgb(231,196,31)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"899.13" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<=
title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D=
"565" width=3D"19.2" height=3D"15.0" fill=3D"rgb(233,183,13)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>=
shmem_fault (573,879,416 samples, 0.15%)</title><rect x=3D"128.9" y=3D"1637=
" width=3D"1.8" height=3D"15.0" fill=3D"rgb(216,180,51)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"131.89" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>kvm_a=
rch_vcpu_ioctl_run (1,488,009,723 samples, 0.40%)</title><rect x=3D"37.7" y=
=3D"1605" width=3D"4.7" height=3D"15.0" fill=3D"rgb(235,108,50)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"40.67" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<titl=
e>native_queued_spin_lock_slowpath (1,180,518,131 samples, 0.32%)</title><r=
ect x=3D"186.0" y=3D"1653" width=3D"3.7" height=3D"15.0" fill=3D"rgb(246,86=
,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.97" y=3D"1663.5" ></text>=0A</=
g>=0A<g >=0A<title>kvm_mmu_page_fault (1,435,810,436 samples, 0.39%)</title=
><rect x=3D"88.2" y=3D"1701" width=3D"4.6" height=3D"15.0" fill=3D"rgb(253,=
191,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.18" y=3D"1711.5" ></text>=0A<=
/g>=0A<g >=0A<title>vmx_handle_exit (2,312,444,881 samples, 0.62%)</title><=
rect x=3D"59.8" y=3D"1637" width=3D"7.4" height=3D"15.0" fill=3D"rgb(224,18=
,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.81" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>is_page_fault_stale (61,025,391 samples, 0.02%)</title><re=
ct x=3D"466.6" y=3D"1893" width=3D"0.2" height=3D"15.0" fill=3D"rgb(254,212=
,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"469.57" y=3D"1903.5" ></text>=0A</g=
>=0A<g >=0A<title>pick_next_task_idle (126,773,385 samples, 0.03%)</title><=
rect x=3D"25.2" y=3D"69" width=3D"0.4" height=3D"15.0" fill=3D"rgb(242,120,=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.24" y=3D"79.5" ></text>=0A</g>=0A=
<g >=0A<title>check_preemption_disabled (230,736,897 samples, 0.06%)</title=
><rect x=3D"48.2" y=3D"1445" width=3D"0.8" height=3D"15.0" fill=3D"rgb(246,=
207,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"51.22" y=3D"1455.5" ></text>=0A=
</g>=0A<g >=0A<title>[unknown] (22,176,419,737 samples, 5.99%)</title><rect=
 x=3D"10.0" y=3D"1797" width=3D"70.6" height=3D"15.0" fill=3D"rgb(244,57,12=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1807.5" >[unknown]</text>=
=0A</g>=0A<g >=0A<title>find_vma (117,015,914 samples, 0.03%)</title><rect =
x=3D"37.7" y=3D"1445" width=3D"0.4" height=3D"15.0" fill=3D"rgb(223,24,5)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1455.5" ></text>=0A</g>=0A<g=
 >=0A<title>workingset_age_nonresident (49,126,693 samples, 0.01%)</title><=
rect x=3D"31.5" y=3D"1445" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218,18=
3,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.54" y=3D"1455.5" ></text>=0A</=
g>=0A<g >=0A<title>_raw_spin_unlock_irqrestore (66,474,340 samples, 0.02%)<=
/title><rect x=3D"217.3" y=3D"1877" width=3D"0.3" height=3D"15.0" fill=3D"r=
gb(225,194,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"220.34" y=3D"1887.5" ></=
text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,134,844,315 samples, 0.=
31%)</title><rect x=3D"143.4" y=3D"1653" width=3D"3.6" height=3D"15.0" fill=
=3D"rgb(248,5,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"146.37" y=3D"1663.5" =
></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</t=
itle><rect x=3D"10.0" y=3D"1349" width=3D"19.2" height=3D"15.0" fill=3D"rgb=
(245,65,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1359.5" ></text=
>=0A</g>=0A<g >=0A<title>[unknown] (6,952,201,475 samples, 1.88%)</title><r=
ect x=3D"10.0" y=3D"1669" width=3D"22.1" height=3D"15.0" fill=3D"rgb(231,82=
,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1679.5" >[..</text>=0A=
</g>=0A<g >=0A<title>mt_find (117,015,914 samples, 0.03%)</title><rect x=3D=
"37.7" y=3D"1429" width=3D"0.4" height=3D"15.0" fill=3D"rgb(213,130,54)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1439.5" ></text>=0A</g>=0A<g >=
=0A<title>vmx_handle_exit (182,037,942 samples, 0.05%)</title><rect x=3D"12=
.7" y=3D"245" width=3D"0.6" height=3D"15.0" fill=3D"rgb(219,150,0)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>unmap_page_range (1,268,054,647 samples, 0.34%)</title><rect x=3D"1184.=
9" y=3D"1893" width=3D"4.0" height=3D"15.0" fill=3D"rgb(243,73,9)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1187.88" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<=
title>get_user_pages_unlocked (1,274,652,040 samples, 0.34%)</title><rect x=
=3D"88.2" y=3D"1637" width=3D"4.1" height=3D"15.0" fill=3D"rgb(243,195,21)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.24" y=3D"1647.5" ></text>=0A</g>=0A<=
g >=0A<title>do_fault (1,134,844,315 samples, 0.31%)</title><rect x=3D"143.=
4" y=3D"1701" width=3D"3.6" height=3D"15.0" fill=3D"rgb(220,21,35)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"146.37" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<=
title>do_raw_spin_unlock (456,231,514 samples, 0.12%)</title><rect x=3D"758=
.2" y=3D"1637" width=3D"1.4" height=3D"15.0" fill=3D"rgb(246,146,46)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"761.16" y=3D"1647.5" ></text>=0A</g>=0A<g >=
=0A<title>native_queued_spin_lock_slowpath (164,972,171 samples, 0.04%)</ti=
tle><rect x=3D"30.9" y=3D"1301" width=3D"0.5" height=3D"15.0" fill=3D"rgb(2=
23,132,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"33.88" y=3D"1311.5" ></text>=
=0A</g>=0A<g >=0A<title>migrate_pages_batch (57,286,183 samples, 0.02%)</ti=
tle><rect x=3D"783.4" y=3D"1765" width=3D"0.2" height=3D"15.0" fill=3D"rgb(=
251,226,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.40" y=3D"1775.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (129,467,492 samples, 0.03%)</tit=
le><rect x=3D"10.4" y=3D"117" width=3D"0.4" height=3D"15.0" fill=3D"rgb(242=
,73,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=3D"127.5" ></text>=0A<=
/g>=0A<g >=0A<title>do_syscall_64 (3,104,413,288 samples, 0.84%)</title><re=
ct x=3D"98.7" y=3D"1829" width=3D"9.9" height=3D"15.0" fill=3D"rgb(214,23,2=
7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.67" y=3D"1839.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (123,051,561 samples, 0.03%)</title><rect x=3D"1=
0.0" y=3D"149" width=3D"0.4" height=3D"15.0" fill=3D"rgb(241,213,25)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<=
title>uncharge_batch (44,194,342 samples, 0.01%)</title><rect x=3D"1174.8" =
y=3D"1797" width=3D"0.2" height=3D"15.0" fill=3D"rgb(222,197,49)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1177.85" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<t=
itle>memcg_stats_lock (314,229,400 samples, 0.08%)</title><rect x=3D"799.0"=
 y=3D"1813" width=3D"1.0" height=3D"15.0" fill=3D"rgb(214,133,20)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"802.01" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<t=
itle>kvm_tdp_page_fault (182,037,942 samples, 0.05%)</title><rect x=3D"12.7=
" y=3D"213" width=3D"0.6" height=3D"15.0" fill=3D"rgb(211,95,22)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"15.69" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<titl=
e>xas_descend (323,775,728 samples, 0.09%)</title><rect x=3D"893.7" y=3D"18=
93" width=3D"1.0" height=3D"15.0" fill=3D"rgb(235,116,2)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"896.71" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>nati=
ve_queued_spin_lock_slowpath (380,476,439 samples, 0.10%)</title><rect x=3D=
"29.7" y=3D"1269" width=3D"1.2" height=3D"15.0" fill=3D"rgb(218,206,11)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"32.67" y=3D"1279.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_vcpu_ioctl (129,467,492 samples, 0.03%)</title><rect x=3D"10.=
4" y=3D"101" width=3D"0.4" height=3D"15.0" fill=3D"rgb(246,128,43)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"13.39" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__get_user_pages (1,407,651,928 samples, 0.38%)</title><rect x=3D"74.2"=
 y=3D"1573" width=3D"4.5" height=3D"15.0" fill=3D"rgb(231,55,35)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"77.19" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__handle_mm_fault (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=
=3D"229" width=3D"2.5" height=3D"15.0" fill=3D"rgb(241,119,43)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"29.48" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>=
scheduler_tick (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D"1=
397" width=3D"0.6" height=3D"15.0" fill=3D"rgb(233,219,42)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"114.26" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>__=
srcu_read_lock (71,724,523 samples, 0.02%)</title><rect x=3D"454.3" y=3D"19=
41" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,204,54)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"457.31" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>mfi=
ll_atomic_install_pte (1,556,228,949 samples, 0.42%)</title><rect x=3D"885.=
2" y=3D"1957" width=3D"5.0" height=3D"15.0" fill=3D"rgb(232,126,39)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"888.20" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A=
<title>native_queued_spin_lock_slowpath (1,130,876,164 samples, 0.31%)</tit=
le><rect x=3D"173.4" y=3D"1637" width=3D"3.6" height=3D"15.0" fill=3D"rgb(2=
14,61,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.45" y=3D"1647.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (1,143,809,245 samples, 0.31%)</title=
><rect x=3D"84.5" y=3D"1781" width=3D"3.7" height=3D"15.0" fill=3D"rgb(232,=
158,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"1791.5" ></text>=0A=
</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (121,177,915 samples,=
 0.03%)</title><rect x=3D"40.8" y=3D"1333" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(208,90,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"43.82" y=3D"1343.5=
" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,319,411,362 samples, =
0.36%)</title><rect x=3D"49.8" y=3D"1701" width=3D"4.2" height=3D"15.0" fil=
l=3D"rgb(241,56,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.75" y=3D"1711.5"=
 ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (61,059,836 samples, 0.02%)=
</title><rect x=3D"58.9" y=3D"1589" width=3D"0.2" height=3D"15.0" fill=3D"r=
gb(210,58,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.87" y=3D"1599.5" ></te=
xt>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (911,547,376 samples, 0.25%)</t=
itle><rect x=3D"29.2" y=3D"1557" width=3D"2.9" height=3D"15.0" fill=3D"rgb(=
211,52,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.24" y=3D"1567.5" ></text>=
=0A</g>=0A<g >=0A<title>do_fault (1,417,843,408 samples, 0.38%)</title><rec=
t x=3D"42.9" y=3D"1445" width=3D"4.5" height=3D"15.0" fill=3D"rgb(249,117,2=
3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86" y=3D"1455.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"1221" width=3D"19.2" height=3D"15.0" fill=3D"rgb(231,51,38)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1231.5" ></text>=0A</g>=0A<g >=
=0A<title>folio_activate_fn (230,736,897 samples, 0.06%)</title><rect x=3D"=
48.2" y=3D"1477" width=3D"0.8" height=3D"15.0" fill=3D"rgb(205,61,12)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"51.22" y=3D"1487.5" ></text>=0A</g>=0A<g >=
=0A<title>dequeue_entity (384,772,501 samples, 0.10%)</title><rect x=3D"164=
.9" y=3D"1605" width=3D"1.3" height=3D"15.0" fill=3D"rgb(223,3,31)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"167.93" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<=
title>kvm_faultin_pfn (1,264,463,727 samples, 0.34%)</title><rect x=3D"49.8=
" y=3D"1557" width=3D"4.0" height=3D"15.0" fill=3D"rgb(210,76,44)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>unmap_region (1,619,511,008 samples, 0.44%)</title><rect x=3D"1183.8" y=
=3D"1925" width=3D"5.1" height=3D"15.0" fill=3D"rgb(249,227,12)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1186.76" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>update_process_times (47,348,631 samples, 0.01%)</title><rect x=3D"706.=
7" y=3D"1605" width=3D"0.1" height=3D"15.0" fill=3D"rgb(254,101,11)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"709.65" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A=
<title>newidle_balance (384,394,743 samples, 0.10%)</title><rect x=3D"27.8"=
 y=3D"85" width=3D"1.2" height=3D"15.0" fill=3D"rgb(240,166,25)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"30.77" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>=
vcpu_enter_guest (3,063,052,576 samples, 0.83%)</title><rect x=3D"132.5" y=
=3D"1845" width=3D"9.8" height=3D"15.0" fill=3D"rgb(206,123,48)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"135.52" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__list_del_entry_valid (88,642,399 samples, 0.02%)</title><rect x=3D"214=
.7" y=3D"1893" width=3D"0.3" height=3D"15.0" fill=3D"rgb(231,138,30)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"217.73" y=3D"1903.5" ></text>=0A</g>=0A<g >=
=0A<title>hva_to_pfn (1,822,628,220 samples, 0.49%)</title><rect x=3D"121.3=
" y=3D"1733" width=3D"5.8" height=3D"15.0" fill=3D"rgb(217,228,26)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"124.26" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<=
title>[unknown] (553,987,799 samples, 0.15%)</title><rect x=3D"10.0" y=3D"2=
29" width=3D"1.8" height=3D"15.0" fill=3D"rgb(246,32,12)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"13.00" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>__vdso=
_clock_gettime (110,798,895 samples, 0.03%)</title><rect x=3D"434.2" y=3D"2=
021" width=3D"0.3" height=3D"15.0" fill=3D"rgb(239,47,9)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"437.20" y=3D"2031.5" ></text>=0A</g>=0A<g >=0A<title>sche=
dule (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"149" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(223,127,20)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"32.00" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>update_process_ti=
mes (49,270,795 samples, 0.01%)</title><rect x=3D"706.3" y=3D"1589" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(250,11,29)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"709.27" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_f=
ault (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=3D"181" width=
=3D"8.0" height=3D"15.0" fill=3D"rgb(214,44,16)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"20.24" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fa=
ult (816,273,154 samples, 0.22%)</title><rect x=3D"29.2" y=3D"1525" width=
=3D"2.6" height=3D"15.0" fill=3D"rgb(224,67,32)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"32.24" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lo=
ck (480,369,154 samples, 0.13%)</title><rect x=3D"129.0" y=3D"1557" width=
=3D"1.5" height=3D"15.0" fill=3D"rgb(250,14,33)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"131.96" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run =
(55,484,525 samples, 0.01%)</title><rect x=3D"88.0" y=3D"1701" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(222,148,27)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"90.99" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (3,3=
48,716,533 samples, 0.90%)</title><rect x=3D"147.5" y=3D"1909" width=3D"10.=
7" height=3D"15.0" fill=3D"rgb(219,117,48)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"150.55" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin=
_lock_slowpath (318,445,705 samples, 0.09%)</title><rect x=3D"129.5" y=3D"1=
541" width=3D"1.0" height=3D"15.0" fill=3D"rgb(247,13,49)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"132.47" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>__i=
ntel_pmu_enable_all.constprop.49 (164,433,311 samples, 0.04%)</title><rect =
x=3D"757.5" y=3D"1653" width=3D"0.6" height=3D"15.0" fill=3D"rgb(238,174,18=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"760.54" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>schedule (158,523,666 samples, 0.04%)</title><rect x=3D"11=
2.1" y=3D"1541" width=3D"0.5" height=3D"15.0" fill=3D"rgb(248,18,18)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"115.10" y=3D"1551.5" ></text>=0A</g>=0A<g >=
=0A<title>__wake_up_common_lock (679,865,538 samples, 0.18%)</title><rect x=
=3D"68.9" y=3D"1429" width=3D"2.2" height=3D"15.0" fill=3D"rgb(253,133,37)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.94" y=3D"1439.5" ></text>=0A</g>=0A<=
g >=0A<title>kvm_tdp_page_fault (98,073,756 samples, 0.03%)</title><rect x=
=3D"11.8" y=3D"85" width=3D"0.3" height=3D"15.0" fill=3D"rgb(224,135,13)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"14.76" y=3D"95.5" ></text>=0A</g>=0A<g >=
=0A<title>schedule (221,899,933 samples, 0.06%)</title><rect x=3D"53.0" y=
=3D"1381" width=3D"0.7" height=3D"15.0" fill=3D"rgb(254,58,1)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"56.03" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title=
>__get_user_pages (1,821,514,697 samples, 0.49%)</title><rect x=3D"42.4" y=
=3D"1493" width=3D"5.8" height=3D"15.0" fill=3D"rgb(235,102,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"45.42" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title=
>find_busiest_group (341,531,787 samples, 0.09%)</title><rect x=3D"769.2" y=
=3D"1637" width=3D"1.0" height=3D"15.0" fill=3D"rgb(222,126,4)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"772.16" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<titl=
e>handle_userfault (2,131,350,080 samples, 0.58%)</title><rect x=3D"112.9" =
y=3D"1573" width=3D"6.7" height=3D"15.0" fill=3D"rgb(239,83,29)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"115.86" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<tit=
le>folio_mark_dirty (468,050,002 samples, 0.13%)</title><rect x=3D"1185.6" =
y=3D"1877" width=3D"1.5" height=3D"15.0" fill=3D"rgb(231,144,2)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1188.59" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>do_syscall_64 (55,652,879,341 samples, 15.03%)</title><rect x=3D"255.2"=
 y=3D"2005" width=3D"177.3" height=3D"15.0" fill=3D"rgb(239,69,35)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"258.23" y=3D"2015.5" >do_syscall_64</text>=0A</=
g>=0A<g >=0A<title>shmem_fault (133,987,142 samples, 0.04%)</title><rect x=
=3D"16.8" y=3D"117" width=3D"0.4" height=3D"15.0" fill=3D"rgb(210,19,31)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"127.5" ></text>=0A</g>=0A<g >=
=0A<title>__GI___ioctl (2,179,708,244 samples, 0.59%)</title><rect x=3D"121=
.2" y=3D"1909" width=3D"7.0" height=3D"15.0" fill=3D"rgb(231,203,28)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"124.25" y=3D"1919.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_mmu_page_fault (2,112,874,408 samples, 0.57%)</title><rect x=
=3D"121.3" y=3D"1781" width=3D"6.7" height=3D"15.0" fill=3D"rgb(213,0,30)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.26" y=3D"1791.5" ></text>=0A</g>=0A<=
g >=0A<title>_raw_spin_lock_irqsave (1,217,462,331 samples, 0.33%)</title><=
rect x=3D"530.4" y=3D"1653" width=3D"3.8" height=3D"15.0" fill=3D"rgb(242,1=
68,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"533.35" y=3D"1663.5" ></text>=0A=
</g>=0A<g >=0A<title>smp_call_function_single (131,563,776 samples, 0.04%)<=
/title><rect x=3D"764.6" y=3D"1621" width=3D"0.4" height=3D"15.0" fill=3D"r=
gb(234,227,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"767.59" y=3D"1631.5" ></=
text>=0A</g>=0A<g >=0A<title>can_migrate_task (114,371,254 samples, 0.03%)<=
/title><rect x=3D"27.8" y=3D"53" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
239,92,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"30.77" y=3D"63.5" ></text>=
=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (175,390,883 sampl=
es, 0.05%)</title><rect x=3D"76.8" y=3D"1429" width=3D"0.6" height=3D"15.0"=
 fill=3D"rgb(210,80,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"79.83" y=3D"143=
9.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (80,050,=
831 samples, 0.02%)</title><rect x=3D"759.7" y=3D"1637" width=3D"0.3" heigh=
t=3D"15.0" fill=3D"rgb(242,52,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"762.7=
4" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>psi_group_change (63,623,46=
6 samples, 0.02%)</title><rect x=3D"146.8" y=3D"1573" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(232,26,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"149.78=
" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,134,844,315 sa=
mples, 0.31%)</title><rect x=3D"143.4" y=3D"1685" width=3D"3.6" height=3D"1=
5.0" fill=3D"rgb(224,3,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"146.37" y=3D=
"1695.5" ></text>=0A</g>=0A<g >=0A<title>exit_to_user_mode_prepare (143,231=
,688 samples, 0.04%)</title><rect x=3D"1170.8" y=3D"1989" width=3D"0.5" hei=
ght=3D"15.0" fill=3D"rgb(236,74,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"117=
3.84" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>copy_user_short_string (=
44,307,534 samples, 0.01%)</title><rect x=3D"902.6" y=3D"1957" width=3D"0.1=
" height=3D"15.0" fill=3D"rgb(208,162,45)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"905.60" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queu=
es (155,141,069 samples, 0.04%)</title><rect x=3D"1032.4" y=3D"1877" width=
=3D"0.5" height=3D"15.0" fill=3D"rgb(236,88,33)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1035.43" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_6=
4 (1,488,009,723 samples, 0.40%)</title><rect x=3D"37.7" y=3D"1653" width=
=3D"4.7" height=3D"15.0" fill=3D"rgb(251,114,31)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"40.67" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>load_balance =
(384,394,743 samples, 0.10%)</title><rect x=3D"27.8" y=3D"69" width=3D"1.2"=
 height=3D"15.0" fill=3D"rgb(225,94,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
30.77" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (116,7=
05,663,902 samples, 31.51%)</title><rect x=3D"460.6" y=3D"1925" width=3D"37=
1.8" height=3D"15.0" fill=3D"rgb(235,136,2)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"463.59" y=3D"1935.5" >kvm_mmu_page_fault</text>=0A</g>=0A<g >=0A<title=
>entry_SYSCALL_64 (1,590,623,571 samples, 0.43%)</title><rect x=3D"54.0" y=
=3D"1717" width=3D"5.1" height=3D"15.0" fill=3D"rgb(231,182,42)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"57.00" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_vcpu_ioctl (2,083,270,665 samples, 0.56%)</title><rect x=3D"172.4" y=
=3D"1957" width=3D"6.6" height=3D"15.0" fill=3D"rgb(251,5,36)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"175.40" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<titl=
e>selinux_file_permission (110,950,804 samples, 0.03%)</title><rect x=3D"26=
5.4" y=3D"1941" width=3D"0.3" height=3D"15.0" fill=3D"rgb(210,214,27)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"268.38" y=3D"1951.5" ></text>=0A</g>=0A<g =
>=0A<title>preempt_count_sub (71,932,586 samples, 0.02%)</title><rect x=3D"=
534.3" y=3D"1637" width=3D"0.2" height=3D"15.0" fill=3D"rgb(244,192,23)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"537.28" y=3D"1647.5" ></text>=0A</g>=0A<g =
>=0A<title>__handle_mm_fault (1,112,111,832 samples, 0.30%)</title><rect x=
=3D"168.5" y=3D"1765" width=3D"3.6" height=3D"15.0" fill=3D"rgb(235,179,52)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.53" y=3D"1775.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_faultin_pfn (790,301,371 samples, 0.21%)</title><rect =
x=3D"26.5" y=3D"309" width=3D"2.5" height=3D"15.0" fill=3D"rgb(221,106,45)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>xas_find (46,110,433 samples, 0.01%)</title><rect x=3D"1178.4" =
y=3D"1829" width=3D"0.1" height=3D"15.0" fill=3D"rgb(250,16,15)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1181.36" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>mtree_range_walk (44,322,517 samples, 0.01%)</title><rect x=3D"885.1" y=
=3D"1925" width=3D"0.1" height=3D"15.0" fill=3D"rgb(245,120,40)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"888.06" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<tit=
le>shmem_fault (1,049,973,543 samples, 0.28%)</title><rect x=3D"50.4" y=3D"=
1429" width=3D"3.3" height=3D"15.0" fill=3D"rgb(231,120,41)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"53.40" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>[u=
nknown] (49,437,419,438 samples, 13.35%)</title><rect x=3D"10.0" y=3D"2005"=
 width=3D"157.5" height=3D"15.0" fill=3D"rgb(232,5,50)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"13.00" y=3D"2015.5" >[unknown]</text>=0A</g>=0A<g >=0A<titl=
e>handle_mm_fault (1,091,339,808 samples, 0.29%)</title><rect x=3D"109.1" y=
=3D"1653" width=3D"3.5" height=3D"15.0" fill=3D"rgb(226,220,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"112.13" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<titl=
e>handle_mm_fault (1,373,790,402 samples, 0.37%)</title><rect x=3D"74.3" y=
=3D"1557" width=3D"4.4" height=3D"15.0" fill=3D"rgb(238,50,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"77.30" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title=
>_raw_spin_lock_irqsave (38,388,608,412 samples, 10.36%)</title><rect x=3D"=
908.2" y=3D"1941" width=3D"122.3" height=3D"15.0" fill=3D"rgb(224,87,3)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"911.20" y=3D"1951.5" >_raw_spin_lock_..</t=
ext>=0A</g>=0A<g >=0A<title>find_vma (528,972,981 samples, 0.14%)</title><r=
ect x=3D"883.5" y=3D"1957" width=3D"1.7" height=3D"15.0" fill=3D"rgb(250,15=
7,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"886.52" y=3D"1967.5" ></text>=0A<=
/g>=0A<g >=0A<title>handle_userfault (573,879,416 samples, 0.15%)</title><r=
ect x=3D"128.9" y=3D"1605" width=3D"1.8" height=3D"15.0" fill=3D"rgb(207,11=
5,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.89" y=3D"1615.5" ></text>=0A<=
/g>=0A<g >=0A<title>sched_clock_cpu (115,623,285 samples, 0.03%)</title><re=
ct x=3D"775.8" y=3D"1669" width=3D"0.4" height=3D"15.0" fill=3D"rgb(209,177=
,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.81" y=3D"1679.5" ></text>=0A</g=
>=0A<g >=0A<title>entry_SYSCALL_64 (1,356,735,820 samples, 0.37%)</title><r=
ect x=3D"128.2" y=3D"1909" width=3D"4.3" height=3D"15.0" fill=3D"rgb(236,21=
7,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1919.5" ></text>=0A<=
/g>=0A<g >=0A<title>release_pages (110,851,886 samples, 0.03%)</title><rect=
 x=3D"1187.3" y=3D"1861" width=3D"0.3" height=3D"15.0" fill=3D"rgb(212,61,8=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.29" y=3D"1871.5" ></text>=0A</g>=
=0A<g >=0A<title>__wake_up_common (38,628,733 samples, 0.01%)</title><rect =
x=3D"74.9" y=3D"1429" width=3D"0.1" height=3D"15.0" fill=3D"rgb(247,124,23)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.92" y=3D"1439.5" ></text>=0A</g>=0A=
<g >=0A<title>shmem_fault (1,293,336,492 samples, 0.35%)</title><rect x=3D"=
185.8" y=3D"1749" width=3D"4.1" height=3D"15.0" fill=3D"rgb(214,5,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"188.75" y=3D"1759.5" ></text>=0A</g>=0A<g =
>=0A<title>vmx_handle_exit (59,449,801 samples, 0.02%)</title><rect x=3D"12=
.5" y=3D"181" width=3D"0.2" height=3D"15.0" fill=3D"rgb(216,192,11)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<t=
itle>vcpu_enter_guest (2,179,708,244 samples, 0.59%)</title><rect x=3D"121.=
2" y=3D"1813" width=3D"7.0" height=3D"15.0" fill=3D"rgb(244,16,1)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"124.25" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__smp_call_single_queue (155,140,884 samples, 0.04%)</title><rect x=3D=
"222.6" y=3D"1861" width=3D"0.5" height=3D"15.0" fill=3D"rgb(252,85,10)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"225.56" y=3D"1871.5" ></text>=0A</g>=0A<g =
>=0A<title>__get_user_pages (2,425,823,890 samples, 0.65%)</title><rect x=
=3D"132.6" y=3D"1733" width=3D"7.7" height=3D"15.0" fill=3D"rgb(245,219,52)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"1743.5" ></text>=0A</g>=
=0A<g >=0A<title>_raw_spin_unlock_irq (354,621,725 samples, 0.10%)</title><=
rect x=3D"273.7" y=3D"1941" width=3D"1.1" height=3D"15.0" fill=3D"rgb(225,2=
22,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"276.70" y=3D"1951.5" ></text>=0A=
</g>=0A<g >=0A<title>do_syscall_64 (129,467,492 samples, 0.03%)</title><rec=
t x=3D"10.4" y=3D"133" width=3D"0.4" height=3D"15.0" fill=3D"rgb(225,5,5)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=3D"143.5" ></text>=0A</g>=0A<g =
>=0A<title>follow_page_pte (281,566,618 samples, 0.08%)</title><rect x=3D"1=
84.9" y=3D"1813" width=3D"0.9" height=3D"15.0" fill=3D"rgb(230,74,29)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"187.86" y=3D"1823.5" ></text>=0A</g>=0A<g =
>=0A<title>__GI___ioctl (182,037,942 samples, 0.05%)</title><rect x=3D"12.7=
" y=3D"357" width=3D"0.6" height=3D"15.0" fill=3D"rgb(252,51,47)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"15.69" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__list_del_entry_valid (66,249,618 samples, 0.02%)</title><rect x=3D"1176=
.2" y=3D"1797" width=3D"0.2" height=3D"15.0" fill=3D"rgb(250,27,11)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1179.18" y=3D"1807.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_arch_vcpu_ioctl_run (133,987,142 samples, 0.04%)</title><rect=
 x=3D"16.8" y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"rgb(240,86,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"335.5" ></text>=0A</g>=0A<g=
 >=0A<title>shmem_fault (1,473,606,899 samples, 0.40%)</title><rect x=3D"61=
.8" y=3D"1461" width=3D"4.6" height=3D"15.0" fill=3D"rgb(231,144,14)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"64.75" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A=
<title>[kvm-intel.ko] (248,409,505 samples, 0.07%)</title><rect x=3D"166.7"=
 y=3D"1861" width=3D"0.8" height=3D"15.0" fill=3D"rgb(220,126,44)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"169.69" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<t=
itle>asm_sysvec_apic_timer_interrupt (571,370,498 samples, 0.15%)</title><r=
ect x=3D"1032.4" y=3D"1941" width=3D"1.8" height=3D"15.0" fill=3D"rgb(217,1=
38,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.43" y=3D"1951.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (1,616,765,146 samples, 0.4=
4%)</title><rect x=3D"88.2" y=3D"1749" width=3D"5.1" height=3D"15.0" fill=
=3D"rgb(218,84,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.17" y=3D"1759.5" =
></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,143,809,245 samples, 0.=
31%)</title><rect x=3D"84.5" y=3D"1797" width=3D"3.7" height=3D"15.0" fill=
=3D"rgb(238,179,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"1807.5"=
 ></text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (166,805,441 samples, 0.=
05%)</title><rect x=3D"53.0" y=3D"1349" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(242,60,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.03" y=3D"1359.5" =
></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,080,385,713 samples, 0.2=
9%)</title><rect x=3D"33.0" y=3D"1509" width=3D"3.4" height=3D"15.0" fill=
=3D"rgb(225,14,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.98" y=3D"1519.5" =
></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (2,060,979,828 samp=
les, 0.56%)</title><rect x=3D"59.9" y=3D"1557" width=3D"6.5" height=3D"15.0=
" fill=3D"rgb(233,79,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.88" y=3D"15=
67.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (643,799,783 samples=
, 0.17%)</title><rect x=3D"29.5" y=3D"1333" width=3D"2.0" height=3D"15.0" f=
ill=3D"rgb(206,159,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.48" y=3D"1343=
.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (2,425,823,890 samples, 0.65=
%)</title><rect x=3D"132.6" y=3D"1765" width=3D"7.7" height=3D"15.0" fill=
=3D"rgb(237,181,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"1775.5=
" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (145,741,482 samples, 0.04=
%)</title><rect x=3D"25.2" y=3D"373" width=3D"0.4" height=3D"15.0" fill=3D"=
rgb(250,90,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"383.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__libc_disable_asynccancel (44,310,233 samples, 0=
.01%)</title><rect x=3D"896.3" y=3D"2053" width=3D"0.2" height=3D"15.0" fil=
l=3D"rgb(237,140,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"899.34" y=3D"2063.=
5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (411,833,993 samples, 0.11%)</=
title><rect x=3D"10.0" y=3D"197" width=3D"1.3" height=3D"15.0" fill=3D"rgb(=
244,98,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"207.5" ></text>=
=0A</g>=0A<g >=0A<title>shmem_fault (1,091,339,808 samples, 0.29%)</title><=
rect x=3D"109.1" y=3D"1589" width=3D"3.5" height=3D"15.0" fill=3D"rgb(214,8=
,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.13" y=3D"1599.5" ></text>=0A</=
g>=0A<g >=0A<title>dequeue_entity (214,920,756 samples, 0.06%)</title><rect=
 x=3D"25.6" y=3D"69" width=3D"0.7" height=3D"15.0" fill=3D"rgb(240,106,13)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"79.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (469,910,857 samples, 0.13%)</title><rect x=3D"=
85.6" y=3D"1477" width=3D"1.5" height=3D"15.0" fill=3D"rgb(238,171,42)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"88.57" y=3D"1487.5" ></text>=0A</g>=0A<g >=
=0A<title>tick_sched_handle.isra.21 (269,433,971 samples, 0.07%)</title><re=
ct x=3D"262.3" y=3D"1861" width=3D"0.9" height=3D"15.0" fill=3D"rgb(251,56,=
49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31" y=3D"1871.5" ></text>=0A</g=
>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=
=3D"10.0" y=3D"1045" width=3D"19.2" height=3D"15.0" fill=3D"rgb(207,228,33)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1055.5" ></text>=0A</g>=0A=
<g >=0A<title>hva_to_pfn (98,073,756 samples, 0.03%)</title><rect x=3D"11.8=
" y=3D"53" width=3D"0.3" height=3D"15.0" fill=3D"rgb(242,130,28)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"14.76" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title=
>vmx_handle_exit (1,435,810,436 samples, 0.39%)</title><rect x=3D"88.2" y=
=3D"1717" width=3D"4.6" height=3D"15.0" fill=3D"rgb(230,185,37)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"91.18" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<titl=
e>tick_sched_handle.isra.21 (160,833,494 samples, 0.04%)</title><rect x=3D"=
834.2" y=3D"1813" width=3D"0.5" height=3D"15.0" fill=3D"rgb(211,9,8)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1823.5" ></text>=0A</g>=0A<g >=
=0A<title>[kvm-intel.ko] (248,409,505 samples, 0.07%)</title><rect x=3D"166=
.7" y=3D"1845" width=3D"0.8" height=3D"15.0" fill=3D"rgb(229,185,22)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"169.69" y=3D"1855.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_release_page_clean (196,324,174 samples, 0.05%)</title><rect =
x=3D"73.1" y=3D"1605" width=3D"0.6" height=3D"15.0" fill=3D"rgb(219,57,46)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"76.06" y=3D"1615.5" ></text>=0A</g>=0A<=
g >=0A<title>hva_to_pfn (1,772,089,566 samples, 0.48%)</title><rect x=3D"18=
4.2" y=3D"1861" width=3D"5.7" height=3D"15.0" fill=3D"rgb(236,74,50)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"187.23" y=3D"1871.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_faultin_pfn (2,131,350,080 samples, 0.58%)</title><rect x=3D"=
112.9" y=3D"1733" width=3D"6.7" height=3D"15.0" fill=3D"rgb(211,10,43)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1743.5" ></text>=0A</g>=0A<g =
>=0A<title>_raw_spin_unlock_irq (68,522,679 samples, 0.02%)</title><rect x=
=3D"13.4" y=3D"53" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,223,11)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"16.43" y=3D"63.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_arch_vcpu_load (44,966,406 samples, 0.01%)</title><rect x=3D"=
171.9" y=3D"1621" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218,106,4)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"174.93" y=3D"1631.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (526,024,177 samples, 0.14%)</title><rect x=3D"=
94.8" y=3D"1477" width=3D"1.7" height=3D"15.0" fill=3D"rgb(239,112,23)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"97.84" y=3D"1487.5" ></text>=0A</g>=0A<g >=
=0A<title>do_raw_spin_lock (55,662,358 samples, 0.02%)</title><rect x=3D"77=
6.4" y=3D"1669" width=3D"0.2" height=3D"15.0" fill=3D"rgb(250,214,7)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"779.40" y=3D"1679.5" ></text>=0A</g>=0A<g >=
=0A<title>do_syscall_64 (1,539,194,524 samples, 0.42%)</title><rect x=3D"16=
7.5" y=3D"1973" width=3D"4.9" height=3D"15.0" fill=3D"rgb(207,220,30)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"170.50" y=3D"1983.5" ></text>=0A</g>=0A<g =
>=0A<title>[kvm-intel.ko] (316,588,044 samples, 0.09%)</title><rect x=3D"79=
.6" y=3D"1653" width=3D"1.0" height=3D"15.0" fill=3D"rgb(209,99,4)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"82.64" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__GI___ioctl (2,913,335,273 samples, 0.79%)</title><rect x=3D"158.2" y=
=3D"1989" width=3D"9.3" height=3D"15.0" fill=3D"rgb(246,118,44)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"161.22" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<tit=
le>native_queued_spin_lock_slowpath (44,979,722 samples, 0.01%)</title><rec=
t x=3D"130.5" y=3D"1573" width=3D"0.1" height=3D"15.0" fill=3D"rgb(219,61,2=
8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.49" y=3D"1583.5" ></text>=0A</g>=
=0A<g >=0A<title>__list_add_valid (265,902,613 samples, 0.07%)</title><rect=
 x=3D"1036.6" y=3D"1941" width=3D"0.8" height=3D"15.0" fill=3D"rgb(214,52,5=
1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1039.59" y=3D"1951.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_faultin_pfn (264,013,792 samples, 0.07%)</title><rect=
 x=3D"25.6" y=3D"293" width=3D"0.9" height=3D"15.0" fill=3D"rgb(247,172,17)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"303.5" ></text>=0A</g>=0A<=
g >=0A<title>ksys_read (55,320,107,944 samples, 14.94%)</title><rect x=3D"2=
55.4" y=3D"1989" width=3D"176.3" height=3D"15.0" fill=3D"rgb(217,171,40)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"258.44" y=3D"1999.5" >ksys_read</text>=0A=
</g>=0A<g >=0A<title>shmem_fault (1,417,843,408 samples, 0.38%)</title><rec=
t x=3D"42.9" y=3D"1413" width=3D"4.5" height=3D"15.0" fill=3D"rgb(239,77,24=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86" y=3D"1423.5" ></text>=0A</g>=
=0A<g >=0A<title>vcpu_enter_guest (2,491,551,090 samples, 0.67%)</title><re=
ct x=3D"17.2" y=3D"325" width=3D"8.0" height=3D"15.0" fill=3D"rgb(252,134,4=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"335.5" ></text>=0A</g>=
=0A<g >=0A<title>preempt_count_sub (78,410,578 samples, 0.02%)</title><rect=
 x=3D"803.3" y=3D"1845" width=3D"0.3" height=3D"15.0" fill=3D"rgb(239,135,4=
2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"806.31" y=3D"1855.5" ></text>=0A</g>=
=0A<g >=0A<title>__sysvec_apic_timer_interrupt (49,270,795 samples, 0.01%)<=
/title><rect x=3D"706.3" y=3D"1669" width=3D"0.1" height=3D"15.0" fill=3D"r=
gb(214,17,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.27" y=3D"1679.5" ></t=
ext>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,422,286,997 samples, 0.38%)</titl=
e><rect x=3D"37.7" y=3D"1509" width=3D"4.6" height=3D"15.0" fill=3D"rgb(224=
,225,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1519.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_map (1,998,006,960 samples, 0.54%)</tit=
le><rect x=3D"811.1" y=3D"1893" width=3D"6.4" height=3D"15.0" fill=3D"rgb(2=
45,111,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"814.14" y=3D"1903.5" ></text=
>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (262,600,218 samples, 0.07%)</title><=
rect x=3D"157.4" y=3D"1861" width=3D"0.8" height=3D"15.0" fill=3D"rgb(239,1=
58,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.38" y=3D"1871.5" ></text>=0A=
</g>=0A<g >=0A<title>syscall_exit_to_user_mode (44,336,313 samples, 0.01%)<=
/title><rect x=3D"438.5" y=3D"1989" width=3D"0.1" height=3D"15.0" fill=3D"r=
gb(205,168,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.49" y=3D"1999.5" ></=
text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (911,547,376 samples, 0.25%)</t=
itle><rect x=3D"29.2" y=3D"1589" width=3D"2.9" height=3D"15.0" fill=3D"rgb(=
223,211,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.24" y=3D"1599.5" ></text=
>=0A</g>=0A<g >=0A<title>in_lock_functions (44,307,997 samples, 0.01%)</tit=
le><rect x=3D"226.9" y=3D"1909" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
17,159,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"229.94" y=3D"1919.5" ></text=
>=0A</g>=0A<g >=0A<title>pick_next_task_fair (54,093,156 samples, 0.01%)</t=
itle><rect x=3D"29.0" y=3D"117" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
50,65,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.02" y=3D"127.5" ></text>=
=0A</g>=0A<g >=0A<title>_raw_spin_unlock (42,319,848 samples, 0.01%)</title=
><rect x=3D"26.3" y=3D"53" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,14=
2,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.33" y=3D"63.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_vcpu_ioctl (159,314,940 samples, 0.04%)</title><rect x=
=3D"10.8" y=3D"117" width=3D"0.5" height=3D"15.0" fill=3D"rgb(220,68,17)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"127.5" ></text>=0A</g>=0A<g >=
=0A<title>[unknown] (755,383,934 samples, 0.20%)</title><rect x=3D"10.0" y=
=3D"277" width=3D"2.4" height=3D"15.0" fill=3D"rgb(247,188,0)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>=
[kvm-intel.ko] (316,588,044 samples, 0.09%)</title><rect x=3D"79.6" y=3D"16=
37" width=3D"1.0" height=3D"15.0" fill=3D"rgb(235,25,47)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"82.64" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>do_ra=
w_spin_lock (261,051,997 samples, 0.07%)</title><rect x=3D"109.3" y=3D"1461=
" width=3D"0.9" height=3D"15.0" fill=3D"rgb(230,160,9)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"112.35" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>vmx_ha=
ndle_exit (1,129,761,195 samples, 0.31%)</title><rect x=3D"80.8" y=3D"1685"=
 width=3D"3.6" height=3D"15.0" fill=3D"rgb(237,55,8)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"83.82" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>psi_acco=
unt_irqtime (282,341,787 samples, 0.08%)</title><rect x=3D"71.4" y=3D"1381"=
 width=3D"0.9" height=3D"15.0" fill=3D"rgb(207,166,20)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"74.36" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>__wake_=
up_common_lock (1,536,632,509 samples, 0.41%)</title><rect x=3D"149.2" y=3D=
"1637" width=3D"4.9" height=3D"15.0" fill=3D"rgb(245,78,14)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"152.18" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>k=
vm_arch_vcpu_ioctl_run (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" =
y=3D"213" width=3D"0.2" height=3D"15.0" fill=3D"rgb(212,137,28)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"15.50" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title=
>finish_task_switch (3,479,902,254 samples, 0.94%)</title><rect x=3D"755.6"=
 y=3D"1685" width=3D"11.1" height=3D"15.0" fill=3D"rgb(215,226,35)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"758.61" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<=
title>__handle_mm_fault (1,167,219,750 samples, 0.32%)</title><rect x=3D"55=
.1" y=3D"1493" width=3D"3.7" height=3D"15.0" fill=3D"rgb(245,43,41)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"58.10" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<=
title>update_rq_clock (43,699,070 samples, 0.01%)</title><rect x=3D"98.2" y=
=3D"1477" width=3D"0.1" height=3D"15.0" fill=3D"rgb(242,220,41)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"101.17" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<tit=
le>pollwake (776,533,745 samples, 0.21%)</title><rect x=3D"149.2" y=3D"1605=
" width=3D"2.5" height=3D"15.0" fill=3D"rgb(230,201,16)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"152.18" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>[unkn=
own] (27,831,478,282 samples, 7.51%)</title><rect x=3D"10.0" y=3D"1861" wid=
th=3D"88.7" height=3D"15.0" fill=3D"rgb(248,222,28)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"1871.5" >[unknown]</text>=0A</g>=0A<g >=0A<title=
>vcpu_enter_guest (1,655,662,953 samples, 0.45%)</title><rect x=3D"142.3" y=
=3D"1861" width=3D"5.2" height=3D"15.0" fill=3D"rgb(223,121,24)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"145.27" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<tit=
le>change_protection (88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=
=3D"1925" width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,210,52)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"900.12" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<tit=
le>mtree_load (96,411,216 samples, 0.03%)</title><rect x=3D"11.8" y=3D"37" =
width=3D"0.3" height=3D"15.0" fill=3D"rgb(216,77,43)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"14.77" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>kvm_unmap_=
gfn_range (41,394,896 samples, 0.01%)</title><rect x=3D"875.4" y=3D"1845" w=
idth=3D"0.1" height=3D"15.0" fill=3D"rgb(229,219,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"878.39" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_lock_irqsave (184,955,698 samples, 0.05%)</title><rect x=3D"89.0" y=3D"1=
477" width=3D"0.6" height=3D"15.0" fill=3D"rgb(238,132,2)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"91.97" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>upda=
te_rq_clock (174,439,060 samples, 0.05%)</title><rect x=3D"106.0" y=3D"1493=
" width=3D"0.6" height=3D"15.0" fill=3D"rgb(213,31,22)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"109.05" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-i=
ntel.ko] (10,392,719,177 samples, 2.81%)</title><rect x=3D"836.2" y=3D"1925=
" width=3D"33.1" height=3D"15.0" fill=3D"rgb(206,171,18)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"839.21" y=3D"1935.5" >[k..</text>=0A</g>=0A<g >=0A<title>=
__GI___ioctl (1,539,194,524 samples, 0.42%)</title><rect x=3D"167.5" y=3D"2=
005" width=3D"4.9" height=3D"15.0" fill=3D"rgb(234,100,39)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"170.50" y=3D"2015.5" ></text>=0A</g>=0A<g >=0A<title>qu=
eued_write_lock_slowpath (110,803,799 samples, 0.03%)</title><rect x=3D"117=
0.9" y=3D"1797" width=3D"0.3" height=3D"15.0" fill=3D"rgb(248,111,52)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1807.5" ></text>=0A</g>=0A<g=
 >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0=
" y=3D"981" width=3D"19.2" height=3D"15.0" fill=3D"rgb(239,66,1)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"13.00" y=3D"991.5" ></text>=0A</g>=0A<g >=0A<titl=
e>_raw_spin_lock_irqsave (1,286,797,459 samples, 0.35%)</title><rect x=3D"1=
00.6" y=3D"1509" width=3D"4.1" height=3D"15.0" fill=3D"rgb(227,85,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"103.63" y=3D"1519.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (663,211,659 samples, 0.18%)</title><rect x=3D"=
69.0" y=3D"1397" width=3D"2.1" height=3D"15.0" fill=3D"rgb(245,103,5)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"71.99" y=3D"1407.5" ></text>=0A</g>=0A<g >=
=0A<title>up_read (237,357,223 samples, 0.06%)</title><rect x=3D"87.1" y=3D=
"1477" width=3D"0.8" height=3D"15.0" fill=3D"rgb(212,29,20)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"90.15" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>[u=
nknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"613" wi=
dth=3D"19.2" height=3D"15.0" fill=3D"rgb(250,224,6)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin=
_lock_irqsave (431,481,042 samples, 0.12%)</title><rect x=3D"149.7" y=3D"15=
73" width=3D"1.3" height=3D"15.0" fill=3D"rgb(209,148,20)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"152.67" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>new=
idle_balance (54,093,156 samples, 0.01%)</title><rect x=3D"29.0" y=3D"101" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(225,219,2)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"32.02" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_=
vcpu_ioctl_run (1,833,266,047 samples, 0.49%)</title><rect x=3D"68.2" y=3D"=
1685" width=3D"5.9" height=3D"15.0" fill=3D"rgb(232,158,18)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"71.24" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>hr=
timer_interrupt (269,433,971 samples, 0.07%)</title><rect x=3D"262.3" y=3D"=
1909" width=3D"0.9" height=3D"15.0" fill=3D"rgb(239,191,46)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"265.31" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>s=
chedule (488,912,619 samples, 0.13%)</title><rect x=3D"96.8" y=3D"1509" wid=
th=3D"1.5" height=3D"15.0" fill=3D"rgb(236,166,41)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"99.75" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_=
guest (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"293" widt=
h=3D"3.5" height=3D"15.0" fill=3D"rgb(229,30,31)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"16.27" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>xfer_to_guest_=
mode_handle_work (48,584,133 samples, 0.01%)</title><rect x=3D"875.4" y=3D"=
1957" width=3D"0.1" height=3D"15.0" fill=3D"rgb(207,201,4)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"878.37" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>kv=
m_mmu_page_fault (1,550,671,371 samples, 0.42%)</title><rect x=3D"142.3" y=
=3D"1829" width=3D"4.9" height=3D"15.0" fill=3D"rgb(229,217,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"145.27" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<titl=
e>preempt_count_add (535,538,961 samples, 0.14%)</title><rect x=3D"534.5" y=
=3D"1653" width=3D"1.7" height=3D"15.0" fill=3D"rgb(213,9,49)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"537.51" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<titl=
e>handle_mm_fault (1,697,771,549 samples, 0.46%)</title><rect x=3D"173.4" y=
=3D"1797" width=3D"5.4" height=3D"15.0" fill=3D"rgb(251,6,48)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"176.38" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<titl=
e>hva_to_pfn (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"117" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(229,50,29)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"15.50" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>[unknown]=
 (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"677" width=3D"=
19.2" height=3D"15.0" fill=3D"rgb(241,204,20)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"13.00" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_ir=
q (470,606,309 samples, 0.13%)</title><rect x=3D"704.7" y=3D"1717" width=3D=
"1.5" height=3D"15.0" fill=3D"rgb(235,105,49)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"707.72" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (=
22,117,643,170 samples, 5.97%)</title><rect x=3D"181.9" y=3D"2005" width=3D=
"70.5" height=3D"15.0" fill=3D"rgb(220,169,44)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"184.90" y=3D"2015.5" >do_sysc..</text>=0A</g>=0A<g >=0A<title>[unkn=
own] (46,524,084,165 samples, 12.56%)</title><rect x=3D"10.0" y=3D"1989" wi=
dth=3D"148.2" height=3D"15.0" fill=3D"rgb(239,91,28)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"1999.5" >[unknown]</text>=0A</g>=0A<g >=0A<title=
>follow_page_mask (258,751,235 samples, 0.07%)</title><rect x=3D"60.9" y=3D=
"1525" width=3D"0.8" height=3D"15.0" fill=3D"rgb(225,78,40)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"63.92" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>vm=
x_handle_exit (123,122,609 samples, 0.03%)</title><rect x=3D"11.4" y=3D"101=
" width=3D"0.4" height=3D"15.0" fill=3D"rgb(250,81,16)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"14.37" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>[unknown=
] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1077" width=
=3D"19.2" height=3D"15.0" fill=3D"rgb(237,109,14)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"13.00" y=3D"1087.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.k=
o] (219,718,564 samples, 0.06%)</title><rect x=3D"49.1" y=3D"1557" width=3D=
"0.7" height=3D"15.0" fill=3D"rgb(205,136,10)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"52.05" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_ti=
mer_interrupt (47,348,631 samples, 0.01%)</title><rect x=3D"706.7" y=3D"168=
5" width=3D"0.1" height=3D"15.0" fill=3D"rgb(229,75,25)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"709.65" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>updat=
e_load_avg (384,772,501 samples, 0.10%)</title><rect x=3D"164.9" y=3D"1589"=
 width=3D"1.3" height=3D"15.0" fill=3D"rgb(212,109,6)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"167.93" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>dequeue=
_entity (310,476,759 samples, 0.08%)</title><rect x=3D"91.1" y=3D"1445" wid=
th=3D"0.9" height=3D"15.0" fill=3D"rgb(221,60,46)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"94.06" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcp=
u_load (52,474,356 samples, 0.01%)</title><rect x=3D"58.2" y=3D"1349" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(223,154,33)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"61.19" y=3D"1359.5" ></text>=0A</g>=0A<g >=0A<title>record_times =
(152,531,113 samples, 0.04%)</title><rect x=3D"106.1" y=3D"1461" width=3D"0=
.5" height=3D"15.0" fill=3D"rgb(246,75,41)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"109.12" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__x86_indirect_thu=
nk_array (85,469,855 samples, 0.02%)</title><rect x=3D"447.1" y=3D"2037" wi=
dth=3D"0.2" height=3D"15.0" fill=3D"rgb(227,210,3)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"450.07" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] =
(50,976,613,962 samples, 13.76%)</title><rect x=3D"10.0" y=3D"2021" width=
=3D"162.4" height=3D"15.0" fill=3D"rgb(220,8,30)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"13.00" y=3D"2031.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>xas_=
load (49,434,611 samples, 0.01%)</title><rect x=3D"13.3" y=3D"53" width=3D"=
0.1" height=3D"15.0" fill=3D"rgb(222,33,48)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"16.27" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>__list_add_valid (11=
0,777,969 samples, 0.03%)</title><rect x=3D"271.0" y=3D"1941" width=3D"0.4"=
 height=3D"15.0" fill=3D"rgb(207,84,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"274.02" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,111,133=
,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"117" width=3D"3.5" height=
=3D"15.0" fill=3D"rgb(234,102,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27=
" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (2,082,264,60=
9 samples, 0.56%)</title><rect x=3D"42.4" y=3D"1589" width=3D"6.7" height=
=3D"15.0" fill=3D"rgb(207,227,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.42=
" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (132,738,87=
8 samples, 0.04%)</title><rect x=3D"897.0" y=3D"2037" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(245,215,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"899.9=
8" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (80,05=
0,831 samples, 0.02%)</title><rect x=3D"759.7" y=3D"1605" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(211,65,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"762=
.74" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (61,757,=
117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"389" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(209,61,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00"=
 y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (47,348,631 s=
amples, 0.01%)</title><rect x=3D"706.7" y=3D"1637" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(223,193,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.65" y=
=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common (3,965,691,750=
 samples, 1.07%)</title><rect x=3D"211.8" y=3D"1925" width=3D"12.6" height=
=3D"15.0" fill=3D"rgb(237,214,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"214.76=
" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (145,741=
,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"133" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(249,127,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18=
" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (269,594,72=
6 samples, 0.07%)</title><rect x=3D"491.1" y=3D"1797" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(206,120,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"494.0=
8" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (12,724,092,53=
9 samples, 3.44%)</title><rect x=3D"834.8" y=3D"1941" width=3D"40.6" height=
=3D"15.0" fill=3D"rgb(243,219,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.8=
3" y=3D"1951.5" >vmx..</text>=0A</g>=0A<g >=0A<title>userfaultfd_wake_funct=
ion (3,121,930,229 samples, 0.84%)</title><rect x=3D"214.4" y=3D"1909" widt=
h=3D"10.0" height=3D"15.0" fill=3D"rgb(210,172,6)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"217.45" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.=
ko] (98,540,330 samples, 0.03%)</title><rect x=3D"67.9" y=3D"1749" width=3D=
"0.3" height=3D"15.0" fill=3D"rgb(218,113,13)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"70.92" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>task_work_run (3=
,024,182,225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"1957" width=3D"=
9.7" height=3D"15.0" fill=3D"rgb(235,209,45)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1177.12" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fa=
ult (3,073,845,719 samples, 0.83%)</title><rect x=3D"147.6" y=3D"1829" widt=
h=3D"9.8" height=3D"15.0" fill=3D"rgb(242,164,39)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"150.56" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release=
_page_clean (206,172,094 samples, 0.06%)</title><rect x=3D"66.5" y=3D"1589"=
 width=3D"0.7" height=3D"15.0" fill=3D"rgb(211,8,34)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"69.50" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>[unknown=
] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1381" width=
=3D"19.2" height=3D"15.0" fill=3D"rgb(207,25,5)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"13.00" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_=
sub (64,377,527 samples, 0.02%)</title><rect x=3D"793.4" y=3D"1845" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(211,145,2)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"796.38" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_loc=
k_irqsave (1,130,876,164 samples, 0.31%)</title><rect x=3D"173.4" y=3D"1669=
" width=3D"3.6" height=3D"15.0" fill=3D"rgb(249,166,14)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"176.45" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>inter=
nal_get_user_pages_fast (160,553,231 samples, 0.04%)</title><rect x=3D"49.8=
" y=3D"1509" width=3D"0.5" height=3D"15.0" fill=3D"rgb(251,216,25)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<t=
itle>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"=
1605" width=3D"19.2" height=3D"15.0" fill=3D"rgb(223,68,3)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"13.00" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>kvm=
_vcpu_ioctl (123,122,609 samples, 0.03%)</title><rect x=3D"11.4" y=3D"149" =
width=3D"0.4" height=3D"15.0" fill=3D"rgb(209,115,39)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"14.37" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm=
_fault (1,473,606,899 samples, 0.40%)</title><rect x=3D"61.8" y=3D"1525" wi=
dth=3D"4.6" height=3D"15.0" fill=3D"rgb(221,215,4)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"64.75" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>native_writ=
e_msr (164,433,311 samples, 0.04%)</title><rect x=3D"757.5" y=3D"1637" widt=
h=3D"0.6" height=3D"15.0" fill=3D"rgb(247,177,36)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"760.54" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vc=
pu_ioctl_run (1,143,809,245 samples, 0.31%)</title><rect x=3D"84.5" y=3D"17=
33" width=3D"3.7" height=3D"15.0" fill=3D"rgb(230,156,44)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"87.52" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>[unk=
nown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1013" wid=
th=3D"19.2" height=3D"15.0" fill=3D"rgb(233,10,18)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"13.00" y=3D"1023.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pa=
ges_unlocked (1,029,735,798 samples, 0.28%)</title><rect x=3D"84.6" y=3D"16=
21" width=3D"3.3" height=3D"15.0" fill=3D"rgb(237,132,25)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"87.63" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>down=
_read (491,296,050 samples, 0.13%)</title><rect x=3D"468.7" y=3D"1861" widt=
h=3D"1.6" height=3D"15.0" fill=3D"rgb(252,229,15)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"471.71" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release=
_page_clean (66,978,108 samples, 0.02%)</title><rect x=3D"147.0" y=3D"1797"=
 width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,50,12)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"149.99" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcp=
u_run (230,259,705 samples, 0.06%)</title><rect x=3D"67.2" y=3D"1637" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(209,107,32)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"70.19" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>task_numa_wor=
k (88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"1957" width=3D"=
0.3" height=3D"15.0" fill=3D"rgb(250,141,38)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"900.12" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (=
98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D"165" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(208,29,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
14.76" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (182,03=
7,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"341" width=3D"0.6" heigh=
t=3D"15.0" fill=3D"rgb(245,27,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69=
" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,161,432,=
362 samples, 0.31%)</title><rect x=3D"38.6" y=3D"1445" width=3D"3.7" height=
=3D"15.0" fill=3D"rgb(245,68,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.55"=
 y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>__get_current_cr3_fast (129,4=
67,492 samples, 0.03%)</title><rect x=3D"10.4" y=3D"37" width=3D"0.4" heigh=
t=3D"15.0" fill=3D"rgb(241,84,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39=
" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (99,714,073 samp=
les, 0.03%)</title><rect x=3D"12.1" y=3D"213" width=3D"0.3" height=3D"15.0"=
 fill=3D"rgb(229,169,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.08" y=3D"22=
3.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,688,676,626 sample=
s, 0.46%)</title><rect x=3D"32.2" y=3D"1653" width=3D"5.4" height=3D"15.0" =
fill=3D"rgb(227,34,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.23" y=3D"1663=
.5" ></text>=0A</g>=0A<g >=0A<title>shmem_truncate_range (3,024,182,225 sam=
ples, 0.82%)</title><rect x=3D"1174.1" y=3D"1877" width=3D"9.7" height=3D"1=
5.0" fill=3D"rgb(237,47,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.12" y=
=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (2,063,=
122,219 samples, 0.56%)</title><rect x=3D"74.1" y=3D"1701" width=3D"6.5" he=
ight=3D"15.0" fill=3D"rgb(235,114,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
7.08" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (2,179,=
708,244 samples, 0.59%)</title><rect x=3D"121.2" y=3D"1893" width=3D"7.0" h=
eight=3D"15.0" fill=3D"rgb(238,43,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
24.25" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.=
21 (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D"1429" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(218,83,20)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"114.26" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl =
(1,198,847,845 samples, 0.32%)</title><rect x=3D"80.6" y=3D"1797" width=3D"=
3.9" height=3D"15.0" fill=3D"rgb(233,156,20)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"83.65" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,=
654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"629" width=3D"19.2" he=
ight=3D"15.0" fill=3D"rgb(252,138,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
.00" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (2,312,=
444,881 samples, 0.62%)</title><rect x=3D"59.8" y=3D"1621" width=3D"7.4" he=
ight=3D"15.0" fill=3D"rgb(242,151,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"6=
2.81" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (3,07=
3,845,719 samples, 0.83%)</title><rect x=3D"147.6" y=3D"1845" width=3D"9.8"=
 height=3D"15.0" fill=3D"rgb(240,146,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"150.56" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>gup_pgd_range (259=
,195,741 samples, 0.07%)</title><rect x=3D"147.6" y=3D"1749" width=3D"0.9" =
height=3D"15.0" fill=3D"rgb(239,27,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
150.63" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (59,449,=
801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"261" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(246,110,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50=
" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (1,027,005,946 samp=
les, 0.28%)</title><rect x=3D"10.0" y=3D"373" width=3D"3.3" height=3D"15.0"=
 fill=3D"rgb(206,193,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"38=
3.5" ></text>=0A</g>=0A<g >=0A<title>native_sched_clock (87,625,763 samples=
, 0.02%)</title><rect x=3D"780.9" y=3D"1653" width=3D"0.3" height=3D"15.0" =
fill=3D"rgb(238,90,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"783.95" y=3D"1663=
.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (2,240,137,502 samples,=
 0.60%)</title><rect x=3D"99.5" y=3D"1701" width=3D"7.1" height=3D"15.0" fi=
ll=3D"rgb(219,211,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.47" y=3D"1711.=
5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (32,382,212 samples, =
0.01%)</title><rect x=3D"26.3" y=3D"37" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(211,51,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.33" y=3D"47.5" ></=
text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</titl=
e><rect x=3D"10.0" y=3D"661" width=3D"19.2" height=3D"15.0" fill=3D"rgb(219=
,56,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"671.5" ></text>=0A<=
/g>=0A<g >=0A<title>do_raw_spin_lock (1,103,520,998 samples, 0.30%)</title>=
<rect x=3D"62.2" y=3D"1381" width=3D"3.5" height=3D"15.0" fill=3D"rgb(236,8=
,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"65.18" y=3D"1391.5" ></text>=0A</g=
>=0A<g >=0A<title>scheduler_tick (110,814,304 samples, 0.03%)</title><rect =
x=3D"903.5" y=3D"1813" width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,22,19)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.47" y=3D"1823.5" ></text>=0A</g>=
=0A<g >=0A<title>handle_userfault (1,989,657,964 samples, 0.54%)</title><re=
ct x=3D"149.1" y=3D"1653" width=3D"6.4" height=3D"15.0" fill=3D"rgb(223,125=
,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"152.14" y=3D"1663.5" ></text>=0A</=
g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (628,142,401 samples, 0=
.17%)</title><rect x=3D"143.7" y=3D"1573" width=3D"2.0" height=3D"15.0" fil=
l=3D"rgb(234,6,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"146.71" y=3D"1583.5"=
 ></text>=0A</g>=0A<g >=0A<title>do_fault (2,079,126,509 samples, 0.56%)</t=
itle><rect x=3D"100.0" y=3D"1605" width=3D"6.6" height=3D"15.0" fill=3D"rgb=
(235,24,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.98" y=3D"1615.5" ></tex=
t>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,523,136,454 samples, 0.41%)</t=
itle><rect x=3D"122.2" y=3D"1685" width=3D"4.9" height=3D"15.0" fill=3D"rgb=
(216,25,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.22" y=3D"1695.5" ></tex=
t>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (55,484,525 samples, 0.01%)</title=
><rect x=3D"88.0" y=3D"1669" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,=
207,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"90.99" y=3D"1679.5" ></text>=0A=
</g>=0A<g >=0A<title>__get_user_pages (1,803,326,472 samples, 0.49%)</title=
><rect x=3D"121.3" y=3D"1701" width=3D"5.8" height=3D"15.0" fill=3D"rgb(220=
,204,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.32" y=3D"1711.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_write_lock (66,260,781 samples, 0.02%)</titl=
e><rect x=3D"897.1" y=3D"1813" width=3D"0.2" height=3D"15.0" fill=3D"rgb(23=
1,4,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"1823.5" ></text>=
=0A</g>=0A<g >=0A<title>release_pages (972,677,125 samples, 0.26%)</title><=
rect x=3D"1174.3" y=3D"1829" width=3D"3.1" height=3D"15.0" fill=3D"rgb(240,=
103,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.28" y=3D"1839.5" ></text>=
=0A</g>=0A<g >=0A<title>__GI___ioctl (98,073,756 samples, 0.03%)</title><re=
ct x=3D"11.8" y=3D"229" width=3D"0.3" height=3D"15.0" fill=3D"rgb(208,112,9=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.76" y=3D"239.5" ></text>=0A</g>=0A=
<g >=0A<title>__get_user_pages (133,987,142 samples, 0.04%)</title><rect x=
=3D"16.8" y=3D"197" width=3D"0.4" height=3D"15.0" fill=3D"rgb(245,32,38)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"207.5" ></text>=0A</g>=0A<g >=
=0A<title>shmem_fault (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" =
y=3D"181" width=3D"2.5" height=3D"15.0" fill=3D"rgb(253,107,29)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"29.48" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title=
>shmem_get_folio_gfp (643,799,783 samples, 0.17%)</title><rect x=3D"29.5" y=
=3D"1349" width=3D"2.0" height=3D"15.0" fill=3D"rgb(212,148,24)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"32.48" y=3D"1359.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__GI___ioctl (23,292,483,788 samples, 6.29%)</title><rect x=3D"179.0" y=
=3D"2037" width=3D"74.2" height=3D"15.0" fill=3D"rgb(211,134,8)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"182.04" y=3D"2047.5" >__GI___i..</text>=0A</g>=0A<=
g >=0A<title>update_rq_clock (840,773,788 samples, 0.23%)</title><rect x=3D=
"778.5" y=3D"1685" width=3D"2.7" height=3D"15.0" fill=3D"rgb(216,112,30)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"781.55" y=3D"1695.5" ></text>=0A</g>=0A<g=
 >=0A<title>__wake_up_common_lock (480,369,154 samples, 0.13%)</title><rect=
 x=3D"129.0" y=3D"1589" width=3D"1.5" height=3D"15.0" fill=3D"rgb(251,197,9=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.96" y=3D"1599.5" ></text>=0A</g>=
=0A<g >=0A<title>__wake_up_common (3,406,367,664 samples, 0.92%)</title><re=
ct x=3D"526.4" y=3D"1701" width=3D"10.9" height=3D"15.0" fill=3D"rgb(230,15=
2,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"529.41" y=3D"1711.5" ></text>=0A<=
/g>=0A<g >=0A<title>__pthread_disable_asynccancel (44,318,802 samples, 0.01=
%)</title><rect x=3D"433.9" y=3D"2037" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(240,6,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"436.87" y=3D"2047.5" =
></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (3,063,052,576 samples, 0.=
83%)</title><rect x=3D"132.5" y=3D"1925" width=3D"9.8" height=3D"15.0" fill=
=3D"rgb(251,194,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.52" y=3D"1935.5=
" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (145,741,482 samples, 0.0=
4%)</title><rect x=3D"25.2" y=3D"213" width=3D"0.4" height=3D"15.0" fill=3D=
"rgb(249,74,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"223.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,319,411,362 samples, 0.36%)</t=
itle><rect x=3D"49.8" y=3D"1653" width=3D"4.2" height=3D"15.0" fill=3D"rgb(=
247,62,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.75" y=3D"1663.5" ></text>=
=0A</g>=0A<g >=0A<title>handle_mm_fault (1,465,325,974 samples, 0.40%)</tit=
le><rect x=3D"142.3" y=3D"1733" width=3D"4.7" height=3D"15.0" fill=3D"rgb(2=
10,34,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"145.32" y=3D"1743.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,422,286,997 samples, 0.38%)</tit=
le><rect x=3D"37.7" y=3D"1525" width=3D"4.6" height=3D"15.0" fill=3D"rgb(22=
2,17,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1535.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (1,356,735,820 samples, 0.37%)</title=
><rect x=3D"128.2" y=3D"1893" width=3D"4.3" height=3D"15.0" fill=3D"rgb(211=
,29,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1903.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (503,613,302 samples, 0.14%)</titl=
e><rect x=3D"177.0" y=3D"1685" width=3D"1.7" height=3D"15.0" fill=3D"rgb(23=
7,33,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"180.05" y=3D"1695.5" ></text>=
=0A</g>=0A<g >=0A<title>scheduler_tick (132,976,269 samples, 0.04%)</title>=
<rect x=3D"1032.5" y=3D"1813" width=3D"0.4" height=3D"15.0" fill=3D"rgb(206=
,91,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.50" y=3D"1823.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (123,051,561 samples, 0.03%=
)</title><rect x=3D"10.0" y=3D"53" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(234,127,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"63.5" ></text=
>=0A</g>=0A<g >=0A<title>shmem_fault (1,075,357,417 samples, 0.29%)</title>=
<rect x=3D"68.8" y=3D"1477" width=3D"3.5" height=3D"15.0" fill=3D"rgb(235,1=
19,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.83" y=3D"1487.5" ></text>=0A</=
g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (469,910,857 samples, 0=
.13%)</title><rect x=3D"85.6" y=3D"1461" width=3D"1.5" height=3D"15.0" fill=
=3D"rgb(243,111,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"88.57" y=3D"1471.5"=
 ></text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (214,920,756 samples, 0.=
06%)</title><rect x=3D"25.6" y=3D"85" width=3D"0.7" height=3D"15.0" fill=3D=
"rgb(231,218,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"95.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (133,987,142 samples, 0.04%)</t=
itle><rect x=3D"16.8" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(2=
41,157,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"367.5" ></text>=
=0A</g>=0A<g >=0A<title>__poll (86,844,848,665 samples, 23.45%)</title><rec=
t x=3D"897.5" y=3D"2053" width=3D"276.6" height=3D"15.0" fill=3D"rgb(232,20=
6,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.45" y=3D"2063.5" >__poll</tex=
t>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,616,765,146 samples, 0.44%)</=
title><rect x=3D"88.2" y=3D"1813" width=3D"5.1" height=3D"15.0" fill=3D"rgb=
(229,113,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.17" y=3D"1823.5" ></text=
>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (59,449,801 samples, 0.02%=
)</title><rect x=3D"12.5" y=3D"101" width=3D"0.2" height=3D"15.0" fill=3D"r=
gb(240,220,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"111.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (816,273,154 samples, 0.22%)<=
/title><rect x=3D"29.2" y=3D"1509" width=3D"2.6" height=3D"15.0" fill=3D"rg=
b(224,34,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.24" y=3D"1519.5" ></text=
>=0A</g>=0A<g >=0A<title>xas_store (198,448,493 samples, 0.05%)</title><rec=
t x=3D"1182.1" y=3D"1797" width=3D"0.6" height=3D"15.0" fill=3D"rgb(208,38,=
16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.07" y=3D"1807.5" ></text>=0A</=
g>=0A<g >=0A<title>do_fault (133,987,142 samples, 0.04%)</title><rect x=3D"=
16.8" y=3D"149" width=3D"0.4" height=3D"15.0" fill=3D"rgb(243,218,22)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"159.5" ></text>=0A</g>=0A<g >=
=0A<title>do_raw_spin_lock (259,217,792 samples, 0.07%)</title><rect x=3D"4=
91.9" y=3D"1813" width=3D"0.9" height=3D"15.0" fill=3D"rgb(209,34,33)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"494.94" y=3D"1823.5" ></text>=0A</g>=0A<g =
>=0A<title>handle_userfault (145,741,482 samples, 0.04%)</title><rect x=3D"=
25.2" y=3D"117" width=3D"0.4" height=3D"15.0" fill=3D"rgb(239,167,53)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"127.5" ></text>=0A</g>=0A<g >=
=0A<title>try_grab_page (180,226,188 samples, 0.05%)</title><rect x=3D"128.=
3" y=3D"1685" width=3D"0.6" height=3D"15.0" fill=3D"rgb(250,11,36)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"131.32" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<=
title>get_user_pages_unlocked (1,110,100,025 samples, 0.30%)</title><rect x=
=3D"109.1" y=3D"1685" width=3D"3.5" height=3D"15.0" fill=3D"rgb(235,197,15)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.07" y=3D"1695.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (760,098,764 samples, 0.21%)</title><rect=
 x=3D"151.7" y=3D"1605" width=3D"2.4" height=3D"15.0" fill=3D"rgb(254,118,1=
4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"154.65" y=3D"1615.5" ></text>=0A</g>=
=0A<g >=0A<title>syscall_exit_to_user_mode_prepare (66,467,170 samples, 0.0=
2%)</title><rect x=3D"252.2" y=3D"1973" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(231,62,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"255.15" y=3D"1983.5"=
 ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (54,729,582 samples, 0.01=
%)</title><rect x=3D"704.5" y=3D"1605" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(216,172,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.49" y=3D"1615.5=
" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (2,344,242,284 samp=
les, 0.63%)</title><rect x=3D"17.2" y=3D"85" width=3D"7.5" height=3D"15.0" =
fill=3D"rgb(250,216,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"95.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,329,332,129 sample=
s, 0.36%)</title><rect x=3D"167.9" y=3D"1861" width=3D"4.2" height=3D"15.0"=
 fill=3D"rgb(221,128,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.89" y=3D"1=
871.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (652,636,124 s=
amples, 0.18%)</title><rect x=3D"109.2" y=3D"1541" width=3D"2.1" height=3D"=
15.0" fill=3D"rgb(238,203,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.19" y=
=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only (259,1=
95,741 samples, 0.07%)</title><rect x=3D"147.6" y=3D"1781" width=3D"0.9" he=
ight=3D"15.0" fill=3D"rgb(210,77,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150=
.63" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (2,628,04=
3,552 samples, 0.71%)</title><rect x=3D"158.3" y=3D"1829" width=3D"8.4" hei=
ght=3D"15.0" fill=3D"rgb(219,147,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16=
1.30" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (32,282,428,09=
8 samples, 8.72%)</title><rect x=3D"10.0" y=3D"1893" width=3D"102.8" height=
=3D"15.0" fill=3D"rgb(218,126,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"1903.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,65=
4,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1205" width=3D"19.2" hei=
ght=3D"15.0" fill=3D"rgb(210,101,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
.00" y=3D"1215.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,682,70=
8,188 samples, 0.45%)</title><rect x=3D"42.9" y=3D"1477" width=3D"5.3" heig=
ht=3D"15.0" fill=3D"rgb(213,94,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86=
" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>is_valid_gup_args (272,276,0=
94 samples, 0.07%)</title><rect x=3D"788.1" y=3D"1845" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(236,103,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"791.1=
0" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (145,741,482 sam=
ples, 0.04%)</title><rect x=3D"25.2" y=3D"85" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(215,165,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"95=
.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (3,024,182,225 samples, 0=
.82%)</title><rect x=3D"1174.1" y=3D"2005" width=3D"9.7" height=3D"15.0" fi=
ll=3D"rgb(211,203,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.12" y=3D"201=
5.5" ></text>=0A</g>=0A<g >=0A<title>__filemap_get_folio (1,211,480,967 sam=
ples, 0.33%)</title><rect x=3D"891.0" y=3D"1925" width=3D"3.8" height=3D"15=
.0" fill=3D"rgb(249,143,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"893.96" y=
=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>userfaultfd_ctx_put (111,919,96=
6 samples, 0.03%)</title><rect x=3D"783.0" y=3D"1717" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(231,182,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.0=
1" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>vma_is_shmem (301,418,944 s=
amples, 0.08%)</title><rect x=3D"894.8" y=3D"1957" width=3D"1.0" height=3D"=
15.0" fill=3D"rgb(250,158,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"897.81" y=
=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>schedule (74,060,258 samples, 0=
.02%)</title><rect x=3D"58.2" y=3D"1397" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(242,183,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.19" y=3D"1407.5" =
></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</t=
itle><rect x=3D"10.0" y=3D"1061" width=3D"19.2" height=3D"15.0" fill=3D"rgb=
(252,208,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1071.5" ></tex=
t>=0A</g>=0A<g >=0A<title>exit_to_user_mode_prepare (88,418,539 samples, 0.=
02%)</title><rect x=3D"897.1" y=3D"1989" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(206,11,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"1999.5"=
 ></text>=0A</g>=0A<g >=0A<title>__schedule (539,769,982 samples, 0.15%)</t=
itle><rect x=3D"104.9" y=3D"1509" width=3D"1.7" height=3D"15.0" fill=3D"rgb=
(250,166,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"107.88" y=3D"1519.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__audit_syscall_exit (44,319,389 samples, 0.01%)=
</title><rect x=3D"1172.0" y=3D"1973" width=3D"0.1" height=3D"15.0" fill=3D=
"rgb(222,65,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1175.00" y=3D"1983.5" >=
</text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (3,104,413,288 samples, 0.84%=
)</title><rect x=3D"98.7" y=3D"1797" width=3D"9.9" height=3D"15.0" fill=3D"=
rgb(208,96,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.67" y=3D"1807.5" ></=
text>=0A</g>=0A<g >=0A<title>handle_userfault (2,423,604,255 samples, 0.65%=
)</title><rect x=3D"132.6" y=3D"1621" width=3D"7.7" height=3D"15.0" fill=3D=
"rgb(239,229,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"1631.5" >=
</text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,728,704,981 samples, 0.47=
%)</title><rect x=3D"74.1" y=3D"1669" width=3D"5.5" height=3D"15.0" fill=3D=
"rgb(253,26,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.13" y=3D"1679.5" ></=
text>=0A</g>=0A<g >=0A<title>xas_load (109,624,453 samples, 0.03%)</title><=
rect x=3D"88.4" y=3D"1493" width=3D"0.3" height=3D"15.0" fill=3D"rgb(243,16=
8,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36" y=3D"1503.5" ></text>=0A</g=
>=0A<g >=0A<title>entry_SYSCALL_64 (86,069,452,878 samples, 23.24%)</title>=
<rect x=3D"898.2" y=3D"2037" width=3D"274.2" height=3D"15.0" fill=3D"rgb(24=
8,223,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"901.16" y=3D"2047.5" >entry_S=
YSCALL_64</text>=0A</g>=0A<g >=0A<title>preempt_count_sub (88,635,316 sampl=
es, 0.02%)</title><rect x=3D"904.1" y=3D"1941" width=3D"0.3" height=3D"15.0=
" fill=3D"rgb(236,130,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"907.10" y=3D"=
1951.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (1,120,566,227 s=
amples, 0.30%)</title><rect x=3D"32.9" y=3D"1541" width=3D"3.6" height=3D"1=
5.0" fill=3D"rgb(227,83,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.92" y=3D=
"1551.5" ></text>=0A</g>=0A<g >=0A<title>tlb_flush_rmap_batch (376,891,628 =
samples, 0.10%)</title><rect x=3D"1187.6" y=3D"1861" width=3D"1.2" height=
=3D"15.0" fill=3D"rgb(211,85,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.6=
4" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>folio_batch_move_lru (1,373=
,712,175 samples, 0.37%)</title><rect x=3D"798.9" y=3D"1845" width=3D"4.4" =
height=3D"15.0" fill=3D"rgb(208,189,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
801.93" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,=
435,810,436 samples, 0.39%)</title><rect x=3D"88.2" y=3D"1685" width=3D"4.6=
" height=3D"15.0" fill=3D"rgb(221,40,49)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"91.18" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (18,181,4=
91,141 samples, 4.91%)</title><rect x=3D"10.0" y=3D"1765" width=3D"57.9" he=
ight=3D"15.0" fill=3D"rgb(221,155,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
.00" y=3D"1775.5" >[unkno..</text>=0A</g>=0A<g >=0A<title>__GI___ioctl (59,=
449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"293" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(218,14,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.=
50" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (1,28=
6,797,459 samples, 0.35%)</title><rect x=3D"100.6" y=3D"1525" width=3D"4.1"=
 height=3D"15.0" fill=3D"rgb(205,58,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"103.63" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (1,7=
38,575,135 samples, 0.47%)</title><rect x=3D"60.9" y=3D"1541" width=3D"5.5"=
 height=3D"15.0" fill=3D"rgb(218,21,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"63.91" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>_copy_from_user (66,47=
5,880 samples, 0.02%)</title><rect x=3D"902.5" y=3D"1973" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(212,148,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"90=
5.53" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (790=
,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"165" width=3D"2.5" he=
ight=3D"15.0" fill=3D"rgb(253,124,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29=
.48" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (12,357,744,251=
 samples, 3.34%)</title><rect x=3D"741.9" y=3D"1701" width=3D"39.3" height=
=3D"15.0" fill=3D"rgb(245,54,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"744.86"=
 y=3D"1711.5" >__s..</text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1,130,=
876,164 samples, 0.31%)</title><rect x=3D"173.4" y=3D"1653" width=3D"3.6" h=
eight=3D"15.0" fill=3D"rgb(248,217,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
176.45" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,111,133,72=
9 samples, 0.30%)</title><rect x=3D"13.3" y=3D"133" width=3D"3.5" height=3D=
"15.0" fill=3D"rgb(222,190,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=
=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (573,879,416 sam=
ples, 0.15%)</title><rect x=3D"128.9" y=3D"1701" width=3D"1.8" height=3D"15=
.0" fill=3D"rgb(212,111,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.89" y=
=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (2,112,874,408 =
samples, 0.57%)</title><rect x=3D"121.3" y=3D"1797" width=3D"6.7" height=3D=
"15.0" fill=3D"rgb(232,200,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.26" y=
=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (131,427,223 sam=
ples, 0.04%)</title><rect x=3D"92.8" y=3D"1685" width=3D"0.5" height=3D"15.=
0" fill=3D"rgb(235,35,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"95.83" y=3D"1=
695.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.=
63%)</title><rect x=3D"10.0" y=3D"1541" width=3D"19.2" height=3D"15.0" fill=
=3D"rgb(246,229,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1551.5"=
 ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (559,180,=
450 samples, 0.15%)</title><rect x=3D"75.0" y=3D"1397" width=3D"1.8" height=
=3D"15.0" fill=3D"rgb(221,95,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"78.05"=
 y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,381,981,=
405 samples, 0.37%)</title><rect x=3D"93.9" y=3D"1605" width=3D"4.4" height=
=3D"15.0" fill=3D"rgb(206,165,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.91=
" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (1,167,137,3=
70 samples, 0.32%)</title><rect x=3D"80.8" y=3D"1749" width=3D"3.7" height=
=3D"15.0" fill=3D"rgb(227,3,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.75" y=
=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (86=
,554,675 samples, 0.02%)</title><rect x=3D"706.3" y=3D"1685" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(245,126,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"709.27" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (145,=
741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"389" width=3D"0.4" hei=
ght=3D"15.0" fill=3D"rgb(242,5,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.1=
8" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (264,013,=
792 samples, 0.07%)</title><rect x=3D"25.6" y=3D"325" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(252,66,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" =
y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (264,013,792 sa=
mples, 0.07%)</title><rect x=3D"25.6" y=3D"341" width=3D"0.9" height=3D"15.=
0" fill=3D"rgb(254,99,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"3=
51.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,111,133,729 sam=
ples, 0.30%)</title><rect x=3D"13.3" y=3D"245" width=3D"3.5" height=3D"15.0=
" fill=3D"rgb(246,163,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"2=
55.5" ></text>=0A</g>=0A<g >=0A<title>up_read (465,824,162 samples, 0.13%)<=
/title><rect x=3D"789.0" y=3D"1845" width=3D"1.5" height=3D"15.0" fill=3D"r=
gb(237,186,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"791.97" y=3D"1855.5" ></=
text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (1,385,607,43=
9 samples, 0.37%)</title><rect x=3D"160.4" y=3D"1605" width=3D"4.4" height=
=3D"15.0" fill=3D"rgb(214,75,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.38"=
 y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (2,637,779,9=
41 samples, 0.71%)</title><rect x=3D"112.8" y=3D"1877" width=3D"8.4" height=
=3D"15.0" fill=3D"rgb(208,208,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.8=
5" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>unmap_vmas (1,268,054,647 s=
amples, 0.34%)</title><rect x=3D"1184.9" y=3D"1909" width=3D"4.0" height=3D=
"15.0" fill=3D"rgb(213,121,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1187.88"=
 y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (145,741,482 sam=
ples, 0.04%)</title><rect x=3D"25.2" y=3D"437" width=3D"0.4" height=3D"15.0=
" fill=3D"rgb(213,45,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"44=
7.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (182,037,942 samples, 0.05=
%)</title><rect x=3D"12.7" y=3D"69" width=3D"0.6" height=3D"15.0" fill=3D"r=
gb(237,155,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"79.5" ></tex=
t>=0A</g>=0A<g >=0A<title>xas_load (130,134,678 samples, 0.04%)</title><rec=
t x=3D"42.9" y=3D"1365" width=3D"0.4" height=3D"15.0" fill=3D"rgb(207,211,4=
5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86" y=3D"1375.5" ></text>=0A</g>=
=0A<g >=0A<title>check_preemption_disabled (66,014,174 samples, 0.02%)</tit=
le><rect x=3D"1180.1" y=3D"1749" width=3D"0.2" height=3D"15.0" fill=3D"rgb(=
214,87,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.12" y=3D"1759.5" ></tex=
t>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (95,274,222 samples, 0.03%)</title><=
rect x=3D"31.8" y=3D"1541" width=3D"0.3" height=3D"15.0" fill=3D"rgb(244,61=
,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.84" y=3D"1551.5" ></text>=0A</g=
>=0A<g >=0A<title>__do_fault (145,741,482 samples, 0.04%)</title><rect x=3D=
"25.2" y=3D"165" width=3D"0.4" height=3D"15.0" fill=3D"rgb(211,211,40)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"175.5" ></text>=0A</g>=0A<g >=
=0A<title>__wake_up_common (66,326,347 samples, 0.02%)</title><rect x=3D"16=
.8" y=3D"53" width=3D"0.2" height=3D"15.0" fill=3D"rgb(209,198,50)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_tdp_mmu_zap_leafs (41,394,896 samples, 0.01%)</title><rect x=3D"875.=
4" y=3D"1829" width=3D"0.1" height=3D"15.0" fill=3D"rgb(228,16,16)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"878.39" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<=
title>ioctl_has_perm.constprop.59 (243,953,429 samples, 0.07%)</title><rect=
 x=3D"875.7" y=3D"1973" width=3D"0.7" height=3D"15.0" fill=3D"rgb(251,13,14=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"878.67" y=3D"1983.5" ></text>=0A</g>=
=0A<g >=0A<title>__do_fault (1,236,031,354 samples, 0.33%)</title><rect x=
=3D"88.4" y=3D"1557" width=3D"3.9" height=3D"15.0" fill=3D"rgb(238,224,22)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36" y=3D"1567.5" ></text>=0A</g>=0A<=
g >=0A<title>vmx_handle_exit (1,529,563,735 samples, 0.41%)</title><rect x=
=3D"54.0" y=3D"1621" width=3D"4.9" height=3D"15.0" fill=3D"rgb(214,51,28)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=3D"1631.5" ></text>=0A</g>=0A<g=
 >=0A<title>handle_mm_fault (1,132,255,149 samples, 0.31%)</title><rect x=
=3D"168.5" y=3D"1781" width=3D"3.6" height=3D"15.0" fill=3D"rgb(241,107,54)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.47" y=3D"1791.5" ></text>=0A</g>=
=0A<g >=0A<title>native_queued_spin_lock_slowpath (1,103,520,998 samples, 0=
.30%)</title><rect x=3D"62.2" y=3D"1365" width=3D"3.5" height=3D"15.0" fill=
=3D"rgb(250,72,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"65.18" y=3D"1375.5" =
></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (44,126,620 sampl=
es, 0.01%)</title><rect x=3D"1179.6" y=3D"1733" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(253,162,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.63" y=
=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>__gfn_to_pfn_memslot (311,341,0=
20 samples, 0.08%)</title><rect x=3D"467.0" y=3D"1877" width=3D"1.0" height=
=3D"15.0" fill=3D"rgb(212,119,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"469.99=
" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (9,544,457,76=
5 samples, 2.58%)</title><rect x=3D"837.5" y=3D"1909" width=3D"30.4" height=
=3D"15.0" fill=3D"rgb(225,36,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"840.45=
" y=3D"1919.5" >[k..</text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (3,104,=
413,288 samples, 0.84%)</title><rect x=3D"98.7" y=3D"1845" width=3D"9.9" he=
ight=3D"15.0" fill=3D"rgb(244,12,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"10=
1.67" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (32,655,086=
 samples, 0.01%)</title><rect x=3D"98.6" y=3D"1733" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(247,171,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.56" =
y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,417,843=
,408 samples, 0.38%)</title><rect x=3D"42.9" y=3D"1397" width=3D"4.5" heigh=
t=3D"15.0" fill=3D"rgb(210,67,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86=
" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>migrate_pages (57,286,183 sa=
mples, 0.02%)</title><rect x=3D"783.4" y=3D"1781" width=3D"0.2" height=3D"1=
5.0" fill=3D"rgb(237,225,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.40" y=
=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__update_idle_core (65,097,094 =
samples, 0.02%)</title><rect x=3D"770.4" y=3D"1653" width=3D"0.2" height=3D=
"15.0" fill=3D"rgb(207,9,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"773.38" y=
=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>gup_pgd_range (164,415,151 samp=
les, 0.04%)</title><rect x=3D"184.2" y=3D"1813" width=3D"0.6" height=3D"15.=
0" fill=3D"rgb(211,124,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"187.23" y=3D=
"1823.5" ></text>=0A</g>=0A<g >=0A<title>down_read (99,677,443 samples, 0.0=
3%)</title><rect x=3D"93.4" y=3D"1653" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(238,99,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.41" y=3D"1663.5" =
></text>=0A</g>=0A<g >=0A<title>shmem_fault (1,161,432,362 samples, 0.31%)<=
/title><rect x=3D"38.6" y=3D"1397" width=3D"3.7" height=3D"15.0" fill=3D"rg=
b(212,34,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.55" y=3D"1407.5" ></text=
>=0A</g>=0A<g >=0A<title>native_read_msr (360,974,606 samples, 0.10%)</titl=
e><rect x=3D"760.9" y=3D"1637" width=3D"1.1" height=3D"15.0" fill=3D"rgb(22=
3,187,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"763.89" y=3D"1647.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (10,975,547,612 samples, 2.96%)</t=
itle><rect x=3D"706.8" y=3D"1717" width=3D"35.0" height=3D"15.0" fill=3D"rg=
b(211,96,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.80" y=3D"1727.5" >do..=
</text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (248,228,614 samples, 0.07=
%)</title><rect x=3D"138.3" y=3D"1573" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(247,223,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"141.34" y=3D"1583.5=
" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (264,013,792 samples, 0.=
07%)</title><rect x=3D"25.6" y=3D"357" width=3D"0.9" height=3D"15.0" fill=
=3D"rgb(223,170,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"367.5" =
></text>=0A</g>=0A<g >=0A<title>__do_fault (2,491,551,090 samples, 0.67%)</=
title><rect x=3D"17.2" y=3D"149" width=3D"8.0" height=3D"15.0" fill=3D"rgb(=
206,151,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"159.5" ></text>=
=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><re=
ct x=3D"10.0" y=3D"1125" width=3D"19.2" height=3D"15.0" fill=3D"rgb(254,214=
,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1135.5" ></text>=0A</g=
>=0A<g >=0A<title>__libc_enable_asynccancel (44,326,320 samples, 0.01%)</ti=
tle><rect x=3D"896.5" y=3D"2053" width=3D"0.1" height=3D"15.0" fill=3D"rgb(=
224,120,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"899.48" y=3D"2063.5" ></tex=
t>=0A</g>=0A<g >=0A<title>set_next_task_idle (85,040,880 samples, 0.02%)</t=
itle><rect x=3D"770.3" y=3D"1669" width=3D"0.3" height=3D"15.0" fill=3D"rgb=
(231,142,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"773.31" y=3D"1679.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (1,778,957,439 samples, 0.48%=
)</title><rect x=3D"68.2" y=3D"1637" width=3D"5.7" height=3D"15.0" fill=3D"=
rgb(239,84,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1647.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq (97,087,917 samples, 0=
.03%)</title><rect x=3D"754.9" y=3D"1637" width=3D"0.3" height=3D"15.0" fil=
l=3D"rgb(235,196,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"757.86" y=3D"1647.=
5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (571,370,4=
98 samples, 0.15%)</title><rect x=3D"1032.4" y=3D"1909" width=3D"1.8" heigh=
t=3D"15.0" fill=3D"rgb(242,107,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.=
43" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_load (130,22=
3,631 samples, 0.04%)</title><rect x=3D"35.8" y=3D"1285" width=3D"0.4" heig=
ht=3D"15.0" fill=3D"rgb(249,118,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.=
82" y=3D"1295.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (1=
,326,971,558 samples, 0.36%)</title><rect x=3D"108.6" y=3D"1797" width=3D"4=
.2" height=3D"15.0" fill=3D"rgb(242,188,38)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"111.62" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>is_cpu_allowed (4=
4,328,798 samples, 0.01%)</title><rect x=3D"217.6" y=3D"1877" width=3D"0.1"=
 height=3D"15.0" fill=3D"rgb(220,40,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"220.56" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>try_grab_folio (180,5=
28,265 samples, 0.05%)</title><rect x=3D"167.9" y=3D"1765" width=3D"0.6" he=
ight=3D"15.0" fill=3D"rgb(240,67,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"17=
0.89" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_load_vmcs (32,0=
72,084 samples, 0.01%)</title><rect x=3D"58.3" y=3D"1317" width=3D"0.1" hei=
ght=3D"15.0" fill=3D"rgb(239,184,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61=
.26" y=3D"1327.5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (80,=
050,831 samples, 0.02%)</title><rect x=3D"759.7" y=3D"1557" width=3D"0.3" h=
eight=3D"15.0" fill=3D"rgb(236,49,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
62.74" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid =
(442,601,254 samples, 0.12%)</title><rect x=3D"271.4" y=3D"1941" width=3D"1=
.4" height=3D"15.0" fill=3D"rgb(210,25,5)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"274.37" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (=
1,724,589,751 samples, 0.47%)</title><rect x=3D"173.3" y=3D"1813" width=3D"=
5.5" height=3D"15.0" fill=3D"rgb(234,33,43)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"176.30" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_faul=
t (2,278,033,377 samples, 0.62%)</title><rect x=3D"99.5" y=3D"1733" width=
=3D"7.2" height=3D"15.0" fill=3D"rgb(227,141,41)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"102.47" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl=
 (2,063,122,219 samples, 0.56%)</title><rect x=3D"74.1" y=3D"1781" width=3D=
"6.5" height=3D"15.0" fill=3D"rgb(250,44,32)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"77.08" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__vm_munmap (1,61=
9,511,008 samples, 0.44%)</title><rect x=3D"1183.8" y=3D"1973" width=3D"5.1=
" height=3D"15.0" fill=3D"rgb(206,72,37)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1186.76" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (347=
,265,618 samples, 0.09%)</title><rect x=3D"120.1" y=3D"1781" width=3D"1.1" =
height=3D"15.0" fill=3D"rgb(230,139,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"123.14" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,211,902=
,461 samples, 0.33%)</title><rect x=3D"55.0" y=3D"1557" width=3D"3.8" heigh=
t=3D"15.0" fill=3D"rgb(243,1,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.96"=
 y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,041,244=
,058 samples, 0.28%)</title><rect x=3D"128.2" y=3D"1781" width=3D"3.3" heig=
ht=3D"15.0" fill=3D"rgb(205,163,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131=
.19" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (32,431,462 =
samples, 0.01%)</title><rect x=3D"53.9" y=3D"1605" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(215,221,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.85" y=
=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (182,818,067 samples=
, 0.05%)</title><rect x=3D"35.8" y=3D"1317" width=3D"0.6" height=3D"15.0" f=
ill=3D"rgb(208,223,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.77" y=3D"1327=
.5" ></text>=0A</g>=0A<g >=0A<title>free_unref_page_list (329,291,450 sampl=
es, 0.09%)</title><rect x=3D"1183.8" y=3D"1861" width=3D"1.1" height=3D"15.=
0" fill=3D"rgb(215,87,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.83" y=3D"=
1871.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (88,418,539 samples, =
0.02%)</title><rect x=3D"897.1" y=3D"2021" width=3D"0.3" height=3D"15.0" fi=
ll=3D"rgb(216,161,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"2031=
.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (1,838,413,419 sampl=
es, 0.50%)</title><rect x=3D"184.2" y=3D"1909" width=3D"5.8" height=3D"15.0=
" fill=3D"rgb(206,90,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"187.15" y=3D"1=
919.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (182,037,942 samples, 0.0=
5%)</title><rect x=3D"12.7" y=3D"181" width=3D"0.6" height=3D"15.0" fill=3D=
"rgb(239,9,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"191.5" ></te=
xt>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (2,083,270,665 samples, 0.56%)<=
/title><rect x=3D"172.4" y=3D"2005" width=3D"6.6" height=3D"15.0" fill=3D"r=
gb(231,66,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=3D"2015.5" ></t=
ext>=0A</g>=0A<g >=0A<title>down_read_killable (250,464,534 samples, 0.07%)=
</title><rect x=3D"72.3" y=3D"1557" width=3D"0.8" height=3D"15.0" fill=3D"r=
gb(251,186,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"75.26" y=3D"1567.5" ></t=
ext>=0A</g>=0A<g >=0A<title>page_add_file_rmap (66,479,932 samples, 0.02%)<=
/title><rect x=3D"889.7" y=3D"1941" width=3D"0.2" height=3D"15.0" fill=3D"r=
gb(226,59,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"892.74" y=3D"1951.5" ></te=
xt>=0A</g>=0A<g >=0A<title>userfaultfd_read (52,087,203,402 samples, 14.06%=
)</title><rect x=3D"265.7" y=3D"1957" width=3D"166.0" height=3D"15.0" fill=
=3D"rgb(242,84,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"268.74" y=3D"1967.5"=
 >userfaultfd_read</text>=0A</g>=0A<g >=0A<title>shmem_fault (2,079,126,509=
 samples, 0.56%)</title><rect x=3D"100.0" y=3D"1573" width=3D"6.6" height=
=3D"15.0" fill=3D"rgb(209,52,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.98=
" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt =
(160,833,494 samples, 0.04%)</title><rect x=3D"834.2" y=3D"1893" width=3D"0=
.5" height=3D"15.0" fill=3D"rgb(228,30,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"837.18" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>__mod_node_page_st=
ate (309,327,693 samples, 0.08%)</title><rect x=3D"156.3" y=3D"1717" width=
=3D"1.0" height=3D"15.0" fill=3D"rgb(207,105,39)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"159.29" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,=
091,339,808 samples, 0.29%)</title><rect x=3D"109.1" y=3D"1621" width=3D"3.=
5" height=3D"15.0" fill=3D"rgb(243,184,37)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"112.13" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (6=
1,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"325" width=3D"0.2" h=
eight=3D"15.0" fill=3D"rgb(244,134,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
32.00" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (264,013,7=
92 samples, 0.07%)</title><rect x=3D"25.6" y=3D"421" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(231,10,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64"=
 y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (790,3=
01,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"389" width=3D"2.5" heig=
ht=3D"15.0" fill=3D"rgb(214,52,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48=
" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>psi_group_change (357,623,460=
 samples, 0.10%)</title><rect x=3D"139.2" y=3D"1557" width=3D"1.1" height=
=3D"15.0" fill=3D"rgb(242,93,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"142.17"=
 y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (2,491,551,090 sa=
mples, 0.67%)</title><rect x=3D"17.2" y=3D"133" width=3D"8.0" height=3D"15.=
0" fill=3D"rgb(209,144,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"=
143.5" ></text>=0A</g>=0A<g >=0A<title>pick_next_task_fair (384,394,743 sam=
ples, 0.10%)</title><rect x=3D"27.8" y=3D"101" width=3D"1.2" height=3D"15.0=
" fill=3D"rgb(229,107,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"30.77" y=3D"1=
11.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,041,244,058 sample=
s, 0.28%)</title><rect x=3D"128.2" y=3D"1813" width=3D"3.3" height=3D"15.0"=
 fill=3D"rgb(225,158,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1=
823.5" ></text>=0A</g>=0A<g >=0A<title>schedule (389,372,240 samples, 0.11%=
)</title><rect x=3D"91.1" y=3D"1493" width=3D"1.2" height=3D"15.0" fill=3D"=
rgb(219,139,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"94.06" y=3D"1503.5" ></=
text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (116,879,350,211 samples, 31.5=
6%)</title><rect x=3D"460.0" y=3D"1941" width=3D"372.4" height=3D"15.0" fil=
l=3D"rgb(248,60,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"463.04" y=3D"1951.5=
" >vmx_handle_exit</text>=0A</g>=0A<g >=0A<title>__mod_memcg_lruvec_state (=
230,736,897 samples, 0.06%)</title><rect x=3D"48.2" y=3D"1461" width=3D"0.8=
" height=3D"15.0" fill=3D"rgb(221,170,29)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"51.22" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__mod_zone_page_sta=
te (61,380,984 samples, 0.02%)</title><rect x=3D"802.6" y=3D"1813" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(232,186,19)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"805.57" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio=
_gfp (1,678,566,158 samples, 0.45%)</title><rect x=3D"173.4" y=3D"1717" wid=
th=3D"5.4" height=3D"15.0" fill=3D"rgb(251,204,38)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"176.45" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>__get_user=
_pages (1,274,652,040 samples, 0.34%)</title><rect x=3D"88.2" y=3D"1621" wi=
dth=3D"4.1" height=3D"15.0" fill=3D"rgb(245,147,7)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"91.24" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>pud_pgtable=
 (39,511,356 samples, 0.01%)</title><rect x=3D"783.9" y=3D"1797" width=3D"0=
.1" height=3D"15.0" fill=3D"rgb(213,66,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"786.92" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>_copy_from_user (8=
8,642,585 samples, 0.02%)</title><rect x=3D"881.0" y=3D"1973" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(206,149,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"883.96" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (6=
44,922,204 samples, 0.17%)</title><rect x=3D"29.5" y=3D"1429" width=3D"2.0"=
 height=3D"15.0" fill=3D"rgb(228,45,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"32.48" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>dequeue_entity (2,626,=
290,065 samples, 0.71%)</title><rect x=3D"747.2" y=3D"1669" width=3D"8.4" h=
eight=3D"15.0" fill=3D"rgb(239,218,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
750.25" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (3,34=
8,716,533 samples, 0.90%)</title><rect x=3D"147.5" y=3D"1877" width=3D"10.7=
" height=3D"15.0" fill=3D"rgb(245,33,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"150.55" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (104,991=
,582 samples, 0.03%)</title><rect x=3D"147.2" y=3D"1845" width=3D"0.3" heig=
ht=3D"15.0" fill=3D"rgb(242,128,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150=
.21" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>kvm_check_request (957,95=
4,558 samples, 0.26%)</title><rect x=3D"455.6" y=3D"1941" width=3D"3.0" hei=
ght=3D"15.0" fill=3D"rgb(207,35,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"458=
.56" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (948,=
421,280 samples, 0.26%)</title><rect x=3D"81.1" y=3D"1493" width=3D"3.0" he=
ight=3D"15.0" fill=3D"rgb(228,66,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84=
.08" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (948,421,280 s=
amples, 0.26%)</title><rect x=3D"81.1" y=3D"1525" width=3D"3.0" height=3D"1=
5.0" fill=3D"rgb(218,205,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.08" y=
=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>syscall (1,263,467,969 samples,=
 0.34%)</title><rect x=3D"435.9" y=3D"2037" width=3D"4.0" height=3D"15.0" f=
ill=3D"rgb(244,225,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"438.88" y=3D"204=
7.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (790,301,371 samples,=
 0.21%)</title><rect x=3D"26.5" y=3D"149" width=3D"2.5" height=3D"15.0" fil=
l=3D"rgb(252,144,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"159.5"=
 ></text>=0A</g>=0A<g >=0A<title>__perf_event_task_sched_out (134,057,949 s=
amples, 0.04%)</title><rect x=3D"112.1" y=3D"1509" width=3D"0.4" height=3D"=
15.0" fill=3D"rgb(242,41,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.10" y=
=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (430,865,190 samples,=
 0.12%)</title><rect x=3D"10.0" y=3D"213" width=3D"1.4" height=3D"15.0" fil=
l=3D"rgb(236,193,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"223.5"=
 ></text>=0A</g>=0A<g >=0A<title>xas_start (49,434,611 samples, 0.01%)</tit=
le><rect x=3D"13.3" y=3D"37" width=3D"0.1" height=3D"15.0" fill=3D"rgb(221,=
33,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"47.5" ></text>=0A</g=
>=0A<g >=0A<title>__schedule (264,013,792 samples, 0.07%)</title><rect x=3D=
"25.6" y=3D"101" width=3D"0.9" height=3D"15.0" fill=3D"rgb(239,75,51)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"111.5" ></text>=0A</g>=0A<g >=
=0A<title>tick_sched_timer (219,093,086 samples, 0.06%)</title><rect x=3D"7=
82.0" y=3D"1605" width=3D"0.7" height=3D"15.0" fill=3D"rgb(237,35,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=3D"1615.5" ></text>=0A</g>=0A<g =
>=0A<title>ttwu_queue_wakelist (1,503,519,661 samples, 0.41%)</title><rect =
x=3D"219.6" y=3D"1877" width=3D"4.8" height=3D"15.0" fill=3D"rgb(236,122,14=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"222.60" y=3D"1887.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,030,418,030 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"517" width=3D"19.2" height=3D"15.0" fill=3D"rgb(229,188,54)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"527.5" ></text>=0A</g>=0A<g >=
=0A<title>dequeue_entity (290,842,992 samples, 0.08%)</title><rect x=3D"41.=
2" y=3D"1301" width=3D"0.9" height=3D"15.0" fill=3D"rgb(225,3,9)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"44.21" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A<tit=
le>do_syscall_64 (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=
=3D"389" width=3D"8.0" height=3D"15.0" fill=3D"rgb(235,55,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"20.24" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>=
kvm_mmu_page_fault (1,088,324,720 samples, 0.29%)</title><rect x=3D"84.5" y=
=3D"1685" width=3D"3.5" height=3D"15.0" fill=3D"rgb(235,37,26)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"87.52" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title=
>kvm_tdp_page_fault (2,278,033,377 samples, 0.62%)</title><rect x=3D"99.5" =
y=3D"1717" width=3D"7.2" height=3D"15.0" fill=3D"rgb(238,56,29)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"102.47" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_arch_vcpu_ioctl_run (264,013,792 samples, 0.07%)</title><rect x=3D"2=
5.6" y=3D"373" width=3D"0.9" height=3D"15.0" fill=3D"rgb(248,46,2)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>native_queued_spin_lock_slowpath (636,395,837 samples, 0.17%)</title><r=
ect x=3D"50.6" y=3D"1333" width=3D"2.0" height=3D"15.0" fill=3D"rgb(225,44,=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.59" y=3D"1343.5" ></text>=0A</g>=
=0A<g >=0A<title>try_grab_folio (1,535,025,434 samples, 0.41%)</title><rect=
 x=3D"477.8" y=3D"1813" width=3D"4.9" height=3D"15.0" fill=3D"rgb(206,228,5=
2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.84" y=3D"1823.5" ></text>=0A</g>=
=0A<g >=0A<title>__cond_resched_rwlock_write (66,260,781 samples, 0.02%)</t=
itle><rect x=3D"897.1" y=3D"1829" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(246,17,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"1839.5" ></text=
>=0A</g>=0A<g >=0A<title>handle_mm_fault (948,421,280 samples, 0.26%)</titl=
e><rect x=3D"81.1" y=3D"1573" width=3D"3.0" height=3D"15.0" fill=3D"rgb(216=
,11,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.08" y=3D"1583.5" ></text>=0A=
</g>=0A<g >=0A<title>folio_activate_fn (865,004,369 samples, 0.23%)</title>=
<rect x=3D"800.0" y=3D"1829" width=3D"2.8" height=3D"15.0" fill=3D"rgb(254,=
65,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"803.01" y=3D"1839.5" ></text>=0A=
</g>=0A<g >=0A<title>update_sd_lb_stats.constprop.137 (54,093,156 samples, =
0.01%)</title><rect x=3D"29.0" y=3D"53" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(238,197,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.02" y=3D"63.5" >=
</text>=0A</g>=0A<g >=0A<title>handle_mm_fault (2,007,086,022 samples, 0.54=
%)</title><rect x=3D"160.3" y=3D"1765" width=3D"6.4" height=3D"15.0" fill=
=3D"rgb(238,146,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=3D"1775.5=
" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (1,896,941,608 samp=
les, 0.51%)</title><rect x=3D"113.3" y=3D"1557" width=3D"6.1" height=3D"15.=
0" fill=3D"rgb(245,210,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"116.35" y=3D=
"1567.5" ></text>=0A</g>=0A<g >=0A<title>__list_add_valid (60,176,738 sampl=
es, 0.02%)</title><rect x=3D"525.9" y=3D"1717" width=3D"0.2" height=3D"15.0=
" fill=3D"rgb(240,210,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"528.92" y=3D"1=
727.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (34,920,208,039 samples, 9=
.43%)</title><rect x=3D"10.0" y=3D"1909" width=3D"111.2" height=3D"15.0" fi=
ll=3D"rgb(233,99,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1919.5"=
 >[unknown]</text>=0A</g>=0A<g >=0A<title>__libc_read (56,673,765,152 sampl=
es, 15.30%)</title><rect x=3D"253.2" y=3D"2037" width=3D"180.6" height=3D"1=
5.0" fill=3D"rgb(231,28,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"256.24" y=
=3D"2047.5" >__libc_read</text>=0A</g>=0A<g >=0A<title>__fput (3,024,182,22=
5 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"1941" width=3D"9.7" height=
=3D"15.0" fill=3D"rgb(254,76,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.1=
2" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (129,467,4=
92 samples, 0.03%)</title><rect x=3D"10.4" y=3D"69" width=3D"0.4" height=3D=
"15.0" fill=3D"rgb(254,81,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=
=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>rcu_qs (359,747,861 samples, 0.10=
%)</title><rect x=3D"97.0" y=3D"1461" width=3D"1.2" height=3D"15.0" fill=3D=
"rgb(209,37,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"100.03" y=3D"1471.5" ><=
/text>=0A</g>=0A<g >=0A<title>folio_mark_accessed (3,146,620,012 samples, 0=
.85%)</title><rect x=3D"798.3" y=3D"1877" width=3D"10.1" height=3D"15.0" fi=
ll=3D"rgb(242,119,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"801.34" y=3D"1887=
.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,449,277,585 samples,=
 0.39%)</title><rect x=3D"167.5" y=3D"1893" width=3D"4.6" height=3D"15.0" f=
ill=3D"rgb(238,94,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.51" y=3D"1903=
.5" ></text>=0A</g>=0A<g >=0A<title>syscall_trace_enter.isra.17 (66,460,837=
 samples, 0.02%)</title><rect x=3D"438.6" y=3D"1989" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(226,119,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.6=
4" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>gup_pgd_range (160,553,231 =
samples, 0.04%)</title><rect x=3D"49.8" y=3D"1493" width=3D"0.5" height=3D"=
15.0" fill=3D"rgb(240,154,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.76" y=
=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_zap_leafs (132,959,=
376 samples, 0.04%)</title><rect x=3D"1170.9" y=3D"1861" width=3D"0.4" heig=
ht=3D"15.0" fill=3D"rgb(240,146,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173=
.87" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>mmu_topup_memory_caches (=
43,402,654 samples, 0.01%)</title><rect x=3D"817.5" y=3D"1893" width=3D"0.1=
" height=3D"15.0" fill=3D"rgb(234,84,44)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"820.51" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,575,=
061,618 samples, 0.43%)</title><rect x=3D"93.4" y=3D"1669" width=3D"5.0" he=
ight=3D"15.0" fill=3D"rgb(241,201,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96=
.41" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (99,71=
4,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"101" width=3D"0.3" heigh=
t=3D"15.0" fill=3D"rgb(234,152,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.0=
8" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,161,432,=
362 samples, 0.31%)</title><rect x=3D"38.6" y=3D"1365" width=3D"3.7" height=
=3D"15.0" fill=3D"rgb(253,103,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.55=
" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,046,776,2=
58 samples, 0.28%)</title><rect x=3D"80.8" y=3D"1637" width=3D"3.4" height=
=3D"15.0" fill=3D"rgb(219,158,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.82"=
 y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (15=
5,462,288 samples, 0.04%)</title><rect x=3D"431.8" y=3D"1989" width=3D"0.5"=
 height=3D"15.0" fill=3D"rgb(230,146,48)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"434.82" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (=
49,270,795 samples, 0.01%)</title><rect x=3D"706.3" y=3D"1621" width=3D"0.1=
" height=3D"15.0" fill=3D"rgb(206,143,33)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"709.27" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault=
 (2,112,874,408 samples, 0.57%)</title><rect x=3D"121.3" y=3D"1765" width=
=3D"6.7" height=3D"15.0" fill=3D"rgb(213,68,17)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"124.26" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>native_queued=
_spin_lock_slowpath (66,488,316 samples, 0.02%)</title><rect x=3D"1171.0" y=
=3D"1781" width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,5,4)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1174.01" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__schedule (158,523,666 samples, 0.04%)</title><rect x=3D"112.1" y=3D"15=
25" width=3D"0.5" height=3D"15.0" fill=3D"rgb(227,104,29)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"115.10" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>che=
ck_preemption_disabled (66,506,372 samples, 0.02%)</title><rect x=3D"1029.9=
" y=3D"1893" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,214,5)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1032.87" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<=
title>folio_mark_accessed (138,806,509 samples, 0.04%)</title><rect x=3D"42=
.4" y=3D"1461" width=3D"0.5" height=3D"15.0" fill=3D"rgb(245,9,50)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"45.42" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<t=
itle>xas_load (66,070,921 samples, 0.02%)</title><rect x=3D"1182.5" y=3D"17=
81" width=3D"0.2" height=3D"15.0" fill=3D"rgb(224,199,35)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1185.49" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>as=
m_sysvec_apic_timer_interrupt (86,554,675 samples, 0.02%)</title><rect x=3D=
"706.3" y=3D"1701" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,186,8)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"709.27" y=3D"1711.5" ></text>=0A</g>=0A<g =
>=0A<title>__filemap_get_folio (2,864,601,989 samples, 0.77%)</title><rect =
x=3D"501.7" y=3D"1733" width=3D"9.1" height=3D"15.0" fill=3D"rgb(238,127,26=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"504.66" y=3D"1743.5" ></text>=0A</g>=
=0A<g >=0A<title>do_fault (1,473,606,899 samples, 0.40%)</title><rect x=3D"=
61.8" y=3D"1493" width=3D"4.6" height=3D"15.0" fill=3D"rgb(236,136,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"64.75" y=3D"1503.5" ></text>=0A</g>=0A<g >=
=0A<title>vcpu_enter_guest (1,833,266,047 samples, 0.49%)</title><rect x=3D=
"68.2" y=3D"1669" width=3D"5.9" height=3D"15.0" fill=3D"rgb(216,47,22)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1679.5" ></text>=0A</g>=0A<g >=
=0A<title>vcpu_enter_guest (2,083,270,665 samples, 0.56%)</title><rect x=3D=
"172.4" y=3D"1925" width=3D"6.6" height=3D"15.0" fill=3D"rgb(214,167,4)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=3D"1935.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (396,718,160 samples, 0.11%)</title><rect x=3D"=
46.1" y=3D"1365" width=3D"1.2" height=3D"15.0" fill=3D"rgb(220,218,38)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"49.08" y=3D"1375.5" ></text>=0A</g>=0A<g >=
=0A<title>folio_mark_accessed (41,777,437 samples, 0.01%)</title><rect x=3D=
"147.1" y=3D"1781" width=3D"0.1" height=3D"15.0" fill=3D"rgb(248,71,24)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"150.07" y=3D"1791.5" ></text>=0A</g>=0A<g =
>=0A<title>tdp_mmu_zap_leafs (132,959,376 samples, 0.04%)</title><rect x=3D=
"1170.9" y=3D"1845" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,101,52)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1855.5" ></text>=0A</g>=0A=
<g >=0A<title>vmx_vcpu_run (61,059,836 samples, 0.02%)</title><rect x=3D"58=
.9" y=3D"1621" width=3D"0.2" height=3D"15.0" fill=3D"rgb(226,181,24)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"61.87" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A=
<title>kvm_mmu_page_fault (61,757,117 samples, 0.02%)</title><rect x=3D"29.=
0" y=3D"357" width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,201,26)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>kvm_faultin_pfn (1,513,316,000 samples, 0.41%)</title><rect x=3D"68.2" =
y=3D"1605" width=3D"4.9" height=3D"15.0" fill=3D"rgb(206,95,28)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"71.24" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<titl=
e>vmx_vcpu_load (143,690,636 samples, 0.04%)</title><rect x=3D"146.3" y=3D"=
1557" width=3D"0.5" height=3D"15.0" fill=3D"rgb(212,156,45)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"149.33" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>v=
mx_vcpu_run (606,119,248 samples, 0.16%)</title><rect x=3D"140.3" y=3D"1829=
" width=3D"2.0" height=3D"15.0" fill=3D"rgb(207,81,28)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"143.34" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mm=
u_page_fault (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"309"=
 width=3D"0.4" height=3D"15.0" fill=3D"rgb(243,96,26)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"28.18" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>[unknown]=
 (2,138,139,675 samples, 0.58%)</title><rect x=3D"10.0" y=3D"405" width=3D"=
6.8" height=3D"15.0" fill=3D"rgb(240,164,5)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"13.00" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (81=
0,906,304 samples, 0.22%)</title><rect x=3D"128.2" y=3D"1765" width=3D"2.6"=
 height=3D"15.0" fill=3D"rgb(244,27,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"131.19" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>can_migrate_task (51,=
506,394 samples, 0.01%)</title><rect x=3D"96.9" y=3D"1429" width=3D"0.1" he=
ight=3D"15.0" fill=3D"rgb(235,34,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"99=
.86" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (6=
36,395,837 samples, 0.17%)</title><rect x=3D"50.6" y=3D"1365" width=3D"2.0"=
 height=3D"15.0" fill=3D"rgb(240,16,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"53.59" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (264,013,79=
2 samples, 0.07%)</title><rect x=3D"25.6" y=3D"181" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(224,28,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=
=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>schedule (67,660,795 samples, 0.=
02%)</title><rect x=3D"17.0" y=3D"69" width=3D"0.2" height=3D"15.0" fill=3D=
"rgb(247,22,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.02" y=3D"79.5" ></tex=
t>=0A</g>=0A<g >=0A<title>vmx_get_rflags (56,028,602 samples, 0.02%)</title=
><rect x=3D"794.4" y=3D"1829" width=3D"0.1" height=3D"15.0" fill=3D"rgb(234=
,195,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.36" y=3D"1839.5" ></text>=
=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (85,570,248 samples, 0.02%)</title><=
rect x=3D"172.1" y=3D"1877" width=3D"0.3" height=3D"15.0" fill=3D"rgb(230,2=
07,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.13" y=3D"1887.5" ></text>=0A=
</g>=0A<g >=0A<title>[kvm-intel.ko] (552,900,486 samples, 0.15%)</title><re=
ct x=3D"106.8" y=3D"1733" width=3D"1.8" height=3D"15.0" fill=3D"rgb(224,49,=
40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"109.79" y=3D"1743.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_faultin_pfn (1,822,628,220 samples, 0.49%)</title><re=
ct x=3D"121.3" y=3D"1749" width=3D"5.8" height=3D"15.0" fill=3D"rgb(243,72,=
49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.26" y=3D"1759.5" ></text>=0A</g=
>=0A<g >=0A<title>vcpu_enter_guest (1,539,194,524 samples, 0.42%)</title><r=
ect x=3D"167.5" y=3D"1909" width=3D"4.9" height=3D"15.0" fill=3D"rgb(219,13=
5,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.50" y=3D"1919.5" ></text>=0A<=
/g>=0A<g >=0A<title>try_grab_folio (321,481,812 samples, 0.09%)</title><rec=
t x=3D"158.3" y=3D"1749" width=3D"1.1" height=3D"15.0" fill=3D"rgb(232,215,=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.34" y=3D"1759.5" ></text>=0A</g>=
=0A<g >=0A<title>entry_SYSCALL_64 (2,549,679,159 samples, 0.69%)</title><re=
ct x=3D"59.8" y=3D"1733" width=3D"8.1" height=3D"15.0" fill=3D"rgb(239,147,=
5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.80" y=3D"1743.5" ></text>=0A</g>=
=0A<g >=0A<title>entry_SYSCALL_64 (2,491,551,090 samples, 0.67%)</title><re=
ct x=3D"17.2" y=3D"405" width=3D"8.0" height=3D"15.0" fill=3D"rgb(241,133,5=
3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"415.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_handle_exit (2,137,312,641 samples, 0.58%)</title><rec=
t x=3D"112.9" y=3D"1781" width=3D"6.8" height=3D"15.0" fill=3D"rgb(239,115,=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1791.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (844,968,004 samples, 0.23%)</title><rect x=3D"1=
0.0" y=3D"341" width=3D"2.7" height=3D"15.0" fill=3D"rgb(215,129,31)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<=
title>__schedule (80,733,153 samples, 0.02%)</title><rect x=3D"119.4" y=3D"=
1541" width=3D"0.2" height=3D"15.0" fill=3D"rgb(210,58,43)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"122.39" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>_r=
aw_spin_unlock_irqrestore (772,484,651 samples, 0.21%)</title><rect x=3D"10=
32.3" y=3D"1957" width=3D"2.4" height=3D"15.0" fill=3D"rgb(223,110,52)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1035.28" y=3D"1967.5" ></text>=0A</g>=0A<g=
 >=0A<title>__do_fault (1,167,219,750 samples, 0.32%)</title><rect x=3D"55.=
1" y=3D"1461" width=3D"3.7" height=3D"15.0" fill=3D"rgb(247,157,2)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"58.10" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<t=
itle>kvm_tdp_mmu_map (127,001,270 samples, 0.03%)</title><rect x=3D"92.4" y=
=3D"1669" width=3D"0.4" height=3D"15.0" fill=3D"rgb(217,210,19)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"95.35" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__x64_sys_poll (85,017,208,236 samples, 22.95%)</title><rect x=3D"899.8" =
y=3D"2005" width=3D"270.8" height=3D"15.0" fill=3D"rgb(217,114,46)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"902.78" y=3D"2015.5" >__x64_sys_poll</text>=0A<=
/g>=0A<g >=0A<title>mcopy_continue (4,561,016,741 samples, 1.23%)</title><r=
ect x=3D"881.2" y=3D"1973" width=3D"14.6" height=3D"15.0" fill=3D"rgb(227,1=
60,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"884.24" y=3D"1983.5" ></text>=0A=
</g>=0A<g >=0A<title>queued_write_lock_slowpath (44,098,602 samples, 0.01%)=
</title><rect x=3D"897.2" y=3D"1797" width=3D"0.1" height=3D"15.0" fill=3D"=
rgb(238,216,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.19" y=3D"1807.5" ></=
text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,264,463,727 samples, 0.34%)</tit=
le><rect x=3D"49.8" y=3D"1541" width=3D"4.0" height=3D"15.0" fill=3D"rgb(22=
6,148,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1551.5" ></text>=
=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (123,122,609 samples, 0.03%)</title=
><rect x=3D"11.4" y=3D"165" width=3D"0.4" height=3D"15.0" fill=3D"rgb(205,3=
1,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"175.5" ></text>=0A</g=
>=0A<g >=0A<title>hrtimer_interrupt (49,270,795 samples, 0.01%)</title><rec=
t x=3D"706.3" y=3D"1653" width=3D"0.1" height=3D"15.0" fill=3D"rgb(235,83,2=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.27" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>change_protection (41,394,896 samples, 0.01%)</title><rect=
 x=3D"875.4" y=3D"1893" width=3D"0.1" height=3D"15.0" fill=3D"rgb(209,142,3=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"878.39" y=3D"1903.5" ></text>=0A</g>=
=0A<g >=0A<title>__handle_mm_fault (573,879,416 samples, 0.15%)</title><rec=
t x=3D"128.9" y=3D"1685" width=3D"1.8" height=3D"15.0" fill=3D"rgb(253,131,=
38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.89" y=3D"1695.5" ></text>=0A</g=
>=0A<g >=0A<title>do_fault (2,165,906,632 samples, 0.58%)</title><rect x=3D=
"148.6" y=3D"1717" width=3D"6.9" height=3D"15.0" fill=3D"rgb(220,27,8)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"151.58" y=3D"1727.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_faultin_pfn (2,425,823,890 samples, 0.65%)</title><rect x=3D=
"132.6" y=3D"1781" width=3D"7.7" height=3D"15.0" fill=3D"rgb(228,223,53)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"1791.5" ></text>=0A</g>=0A<g=
 >=0A<title>native_queued_spin_lock_slowpath (40,942,170,976 samples, 11.05=
%)</title><rect x=3D"1040.1" y=3D"1909" width=3D"130.4" height=3D"15.0" fil=
l=3D"rgb(242,131,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1043.05" y=3D"1919.=
5" >native_queued_sp..</text>=0A</g>=0A<g >=0A<title>shmem_undo_range (3,02=
4,182,225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"1861" width=3D"9.7=
" height=3D"15.0" fill=3D"rgb(207,104,16)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1177.12" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (133,9=
87,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"133" width=3D"0.4" heig=
ht=3D"15.0" fill=3D"rgb(239,108,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.=
81" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (99,714,07=
3 samples, 0.03%)</title><rect x=3D"12.1" y=3D"229" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(222,153,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.08" y=
=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (221,899,933 samples,=
 0.06%)</title><rect x=3D"53.0" y=3D"1365" width=3D"0.7" height=3D"15.0" fi=
ll=3D"rgb(245,184,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.03" y=3D"1375.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (182,037,942 samples,=
 0.05%)</title><rect x=3D"12.7" y=3D"229" width=3D"0.6" height=3D"15.0" fil=
l=3D"rgb(227,127,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"239.5"=
 ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (2,491,551,090 samples, 0.67%)<=
/title><rect x=3D"17.2" y=3D"245" width=3D"8.0" height=3D"15.0" fill=3D"rgb=
(248,116,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"255.5" ></text=
>=0A</g>=0A<g >=0A<title>avc_has_extended_perms (110,905,340 samples, 0.03%=
)</title><rect x=3D"876.1" y=3D"1957" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(235,183,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"879.09" y=3D"1967.5" >=
</text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (261,051,997 samples,=
 0.07%)</title><rect x=3D"109.3" y=3D"1477" width=3D"0.9" height=3D"15.0" f=
ill=3D"rgb(214,53,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.35" y=3D"1487=
.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only (144,445,061 s=
amples, 0.04%)</title><rect x=3D"68.2" y=3D"1573" width=3D"0.5" height=3D"1=
5.0" fill=3D"rgb(236,148,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=
=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,590,623,571=
 samples, 0.43%)</title><rect x=3D"54.0" y=3D"1637" width=3D"5.1" height=3D=
"15.0" fill=3D"rgb(239,73,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=
=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (264,013,792 samples, =
0.07%)</title><rect x=3D"25.6" y=3D"197" width=3D"0.9" height=3D"15.0" fill=
=3D"rgb(243,105,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"207.5" =
></text>=0A</g>=0A<g >=0A<title>syscall_return_via_sysret (254,224,911 samp=
les, 0.07%)</title><rect x=3D"252.4" y=3D"2021" width=3D"0.8" height=3D"15.=
0" fill=3D"rgb(211,219,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"255.36" y=3D=
"2031.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_load_vmcs (931,264,238 sa=
mples, 0.25%)</title><rect x=3D"762.0" y=3D"1637" width=3D"3.0" height=3D"1=
5.0" fill=3D"rgb(217,95,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"765.04" y=
=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (790,301,371 samples, =
0.21%)</title><rect x=3D"26.5" y=3D"213" width=3D"2.5" height=3D"15.0" fill=
=3D"rgb(231,28,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"223.5" >=
</text>=0A</g>=0A<g >=0A<title>handle_userfault (948,421,280 samples, 0.26%=
)</title><rect x=3D"81.1" y=3D"1477" width=3D"3.0" height=3D"15.0" fill=3D"=
rgb(229,53,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.08" y=3D"1487.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__folio_cancel_dirty (44,136,375 samples, 0.01%=
)</title><rect x=3D"1183.6" y=3D"1813" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(252,9,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.62" y=3D"1823.5"=
 ></text>=0A</g>=0A<g >=0A<title>psi_task_switch (233,679,629 samples, 0.06=
%)</title><rect x=3D"77.9" y=3D"1413" width=3D"0.8" height=3D"15.0" fill=3D=
"rgb(239,225,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80.93" y=3D"1423.5" ><=
/text>=0A</g>=0A<g >=0A<title>find_extend_vma (906,394,688 samples, 0.24%)<=
/title><rect x=3D"484.2" y=3D"1829" width=3D"2.9" height=3D"15.0" fill=3D"r=
gb(217,46,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"487.22" y=3D"1839.5" ></t=
ext>=0A</g>=0A<g >=0A<title>vmx_prepare_switch_to_guest (149,144,559 sample=
s, 0.04%)</title><rect x=3D"119.7" y=3D"1781" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(209,106,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"122.67" y=3D"1=
791.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_gfn_to_memslot (676,642,665=
 samples, 0.18%)</title><rect x=3D"830.2" y=3D"1909" width=3D"2.2" height=
=3D"15.0" fill=3D"rgb(206,124,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"833.24=
" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>folio_mark_accessed (309,327=
,693 samples, 0.08%)</title><rect x=3D"156.3" y=3D"1797" width=3D"1.0" heig=
ht=3D"15.0" fill=3D"rgb(221,98,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"159.=
29" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,326,97=
1,558 samples, 0.36%)</title><rect x=3D"108.6" y=3D"1861" width=3D"4.2" hei=
ght=3D"15.0" fill=3D"rgb(216,59,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111=
.62" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,134,8=
44,315 samples, 0.31%)</title><rect x=3D"143.4" y=3D"1637" width=3D"3.6" he=
ight=3D"15.0" fill=3D"rgb(239,191,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14=
6.37" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run =
(911,547,376 samples, 0.25%)</title><rect x=3D"29.2" y=3D"1573" width=3D"2.=
9" height=3D"15.0" fill=3D"rgb(206,139,51)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"32.24" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl=
_run (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"165" width=3D=
"0.3" height=3D"15.0" fill=3D"rgb(229,63,17)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"15.08" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (785,518=
,203 samples, 0.21%)</title><rect x=3D"10.0" y=3D"293" width=3D"2.5" height=
=3D"15.0" fill=3D"rgb(214,163,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,82=
2,628,220 samples, 0.49%)</title><rect x=3D"121.3" y=3D"1717" width=3D"5.8"=
 height=3D"15.0" fill=3D"rgb(250,85,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"124.26" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,=
099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1269" width=3D"19.2" heigh=
t=3D"15.0" fill=3D"rgb(206,19,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"1279.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (230,259,705 =
samples, 0.06%)</title><rect x=3D"67.2" y=3D"1621" width=3D"0.7" height=3D"=
15.0" fill=3D"rgb(223,126,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"70.19" y=
=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,236,031,354 samples=
, 0.33%)</title><rect x=3D"88.4" y=3D"1573" width=3D"3.9" height=3D"15.0" f=
ill=3D"rgb(224,13,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36" y=3D"1583.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (59,449,801 samples, =
0.02%)</title><rect x=3D"12.5" y=3D"149" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(222,163,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"159.5" =
></text>=0A</g>=0A<g >=0A<title>__perf_event_task_sched_out (1,082,952,047 =
samples, 0.29%)</title><rect x=3D"742.2" y=3D"1685" width=3D"3.5" height=3D=
"15.0" fill=3D"rgb(230,29,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"745.25" y=
=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (1,663,0=
82,890 samples, 0.45%)</title><rect x=3D"132.6" y=3D"1589" width=3D"5.3" he=
ight=3D"15.0" fill=3D"rgb(207,115,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
35.59" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run=
 (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"405" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(242,57,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"32.00" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (389,372,=
240 samples, 0.11%)</title><rect x=3D"91.1" y=3D"1477" width=3D"1.2" height=
=3D"15.0" fill=3D"rgb(250,43,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"94.06"=
 y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>__nr_to_section (44,049,896 s=
amples, 0.01%)</title><rect x=3D"1177.2" y=3D"1781" width=3D"0.2" height=3D=
"15.0" fill=3D"rgb(229,24,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1180.24" =
y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (2,637,779,941 sa=
mples, 0.71%)</title><rect x=3D"112.8" y=3D"1893" width=3D"8.4" height=3D"1=
5.0" fill=3D"rgb(215,207,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.85" y=
=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (2,082,264,6=
09 samples, 0.56%)</title><rect x=3D"42.4" y=3D"1573" width=3D"6.7" height=
=3D"15.0" fill=3D"rgb(247,122,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.42=
" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (45,267,44=
3 samples, 0.01%)</title><rect x=3D"704.3" y=3D"1685" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(223,179,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.2=
8" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>release_pages (150,210,092 =
samples, 0.04%)</title><rect x=3D"802.8" y=3D"1829" width=3D"0.5" height=3D=
"15.0" fill=3D"rgb(213,33,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"805.83" y=
=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (2,491,551,0=
90 samples, 0.67%)</title><rect x=3D"17.2" y=3D"277" width=3D"8.0" height=
=3D"15.0" fill=3D"rgb(240,42,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" =
y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>do_sys_poll (84,995,030,095 sam=
ples, 22.95%)</title><rect x=3D"899.9" y=3D"1989" width=3D"270.7" height=3D=
"15.0" fill=3D"rgb(216,130,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"902.85" =
y=3D"1999.5" >do_sys_poll</text>=0A</g>=0A<g >=0A<title>migrate_misplaced_p=
age (57,286,183 samples, 0.02%)</title><rect x=3D"783.4" y=3D"1797" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(223,217,33)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"786.40" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run=
 (574,342,021 samples, 0.16%)</title><rect x=3D"106.7" y=3D"1749" width=3D"=
1.9" height=3D"15.0" fill=3D"rgb(243,5,33)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"109.73" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_l=
ock (1,663,082,890 samples, 0.45%)</title><rect x=3D"132.6" y=3D"1605" widt=
h=3D"5.3" height=3D"15.0" fill=3D"rgb(219,208,2)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"135.59" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_co=
mmon (39,330,909 samples, 0.01%)</title><rect x=3D"143.6" y=3D"1605" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(253,228,7)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"146.59" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_com=
mon_lock (747,036,892 samples, 0.20%)</title><rect x=3D"33.2" y=3D"1333" wi=
dth=3D"2.4" height=3D"15.0" fill=3D"rgb(213,58,26)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"36.25" y=3D"1343.5" ></text>=0A</g>=0A<g >=0A<title>rcu_note_co=
ntext_switch (584,008,893 samples, 0.16%)</title><rect x=3D"776.7" y=3D"168=
5" width=3D"1.8" height=3D"15.0" fill=3D"rgb(249,8,17)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"779.69" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>do_fau=
lt (1,373,790,402 samples, 0.37%)</title><rect x=3D"74.3" y=3D"1525" width=
=3D"4.4" height=3D"15.0" fill=3D"rgb(206,26,12)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"77.30" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_=
spin_lock_slowpath (6,321,644,052 samples, 1.71%)</title><rect x=3D"228.4" =
y=3D"1925" width=3D"20.2" height=3D"15.0" fill=3D"rgb(217,213,15)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"231.42" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<t=
itle>do_raw_spin_lock (46,696,073,374 samples, 12.61%)</title><rect x=3D"28=
2.9" y=3D"1941" width=3D"148.8" height=3D"15.0" fill=3D"rgb(216,29,41)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"285.91" y=3D"1951.5" >do_raw_spin_lock</te=
xt>=0A</g>=0A<g >=0A<title>schedule (617,505,546 samples, 0.17%)</title><re=
ct x=3D"138.3" y=3D"1605" width=3D"2.0" height=3D"15.0" fill=3D"rgb(217,121=
,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"141.34" y=3D"1615.5" ></text>=0A</=
g>=0A<g >=0A<title>__x64_sys_ioctl (1,488,009,723 samples, 0.40%)</title><r=
ect x=3D"37.7" y=3D"1637" width=3D"4.7" height=3D"15.0" fill=3D"rgb(236,53,=
28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.67" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>handle_userfault (1,287,708,730 samples, 0.35%)</title><re=
ct x=3D"43.3" y=3D"1381" width=3D"4.1" height=3D"15.0" fill=3D"rgb(234,6,3)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"46.28" y=3D"1391.5" ></text>=0A</g>=0A=
<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10=
.0" y=3D"757" width=3D"19.2" height=3D"15.0" fill=3D"rgb(242,153,5)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"767.5" ></text>=0A</g>=0A<g >=0A<t=
itle>native_queued_spin_lock_slowpath (175,944,891 samples, 0.05%)</title><=
rect x=3D"130.9" y=3D"1749" width=3D"0.6" height=3D"15.0" fill=3D"rgb(231,1=
14,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.95" y=3D"1759.5" ></text>=0A=
</g>=0A<g >=0A<title>do_raw_spin_lock (916,432,497 samples, 0.25%)</title><=
rect x=3D"886.7" y=3D"1941" width=3D"3.0" height=3D"15.0" fill=3D"rgb(237,6=
5,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"889.75" y=3D"1951.5" ></text>=0A<=
/g>=0A<g >=0A<title>handle_mm_fault (1,075,357,417 samples, 0.29%)</title><=
rect x=3D"68.8" y=3D"1541" width=3D"3.5" height=3D"15.0" fill=3D"rgb(207,78=
,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.83" y=3D"1551.5" ></text>=0A</g=
>=0A<g >=0A<title>__GI___ioctl (1,346,536,528 samples, 0.36%)</title><rect =
x=3D"108.6" y=3D"1877" width=3D"4.2" height=3D"15.0" fill=3D"rgb(206,143,6)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.56" y=3D"1887.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (175,390,883 samples, 0.05%)</title><rect=
 x=3D"76.8" y=3D"1445" width=3D"0.6" height=3D"15.0" fill=3D"rgb(221,88,9)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"79.83" y=3D"1455.5" ></text>=0A</g>=0A<=
g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.=
0" y=3D"949" width=3D"19.2" height=3D"15.0" fill=3D"rgb(249,211,24)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"959.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__srcu_read_lock (212,952,356 samples, 0.06%)</title><rect x=3D"32.2" =
y=3D"1557" width=3D"0.7" height=3D"15.0" fill=3D"rgb(210,175,54)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"35.24" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<tit=
le>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"80=
5" width=3D"19.2" height=3D"15.0" fill=3D"rgb(231,172,16)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"13.00" y=3D"815.5" ></text>=0A</g>=0A<g >=0A<title>finis=
h_task_switch (405,906,628 samples, 0.11%)</title><rect x=3D"26.5" y=3D"101=
" width=3D"1.3" height=3D"15.0" fill=3D"rgb(215,92,45)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"29.48" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_=
page_fault (2,433,229,386 samples, 0.66%)</title><rect x=3D"132.6" y=3D"179=
7" width=3D"7.7" height=3D"15.0" fill=3D"rgb(219,139,50)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"135.58" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>hand=
le_userfault (1,075,357,417 samples, 0.29%)</title><rect x=3D"68.8" y=3D"14=
45" width=3D"3.5" height=3D"15.0" fill=3D"rgb(231,210,27)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"71.83" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>_raw=
_read_unlock (281,473,741 samples, 0.08%)</title><rect x=3D"172.4" y=3D"186=
1" width=3D"0.9" height=3D"15.0" fill=3D"rgb(237,64,34)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"175.40" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>vmx_v=
cpu_load (402,390,541 samples, 0.11%)</title><rect x=3D"26.5" y=3D"69" widt=
h=3D"1.3" height=3D"15.0" fill=3D"rgb(231,199,32)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"29.49" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>uffd_handler_t=
hread_fn (88,711,499 samples, 0.02%)</title><rect x=3D"1189.7" y=3D"2053" w=
idth=3D"0.3" height=3D"15.0" fill=3D"rgb(244,13,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1192.68" y=3D"2063.5" ></text>=0A</g>=0A<g >=0A<title>_raw_s=
pin_lock_irqsave (1,103,520,998 samples, 0.30%)</title><rect x=3D"62.2" y=
=3D"1397" width=3D"3.5" height=3D"15.0" fill=3D"rgb(209,23,17)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"65.18" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title=
>__handle_mm_fault (1,293,336,492 samples, 0.35%)</title><rect x=3D"185.8" =
y=3D"1797" width=3D"4.1" height=3D"15.0" fill=3D"rgb(231,5,20)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"188.75" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<titl=
e>preempt_count_add (66,502,014 samples, 0.02%)</title><rect x=3D"226.1" y=
=3D"1909" width=3D"0.2" height=3D"15.0" fill=3D"rgb(222,169,24)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"229.09" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__x64_sys_ioctl (1,326,971,558 samples, 0.36%)</title><rect x=3D"108.6" =
y=3D"1829" width=3D"4.2" height=3D"15.0" fill=3D"rgb(205,95,47)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"111.62" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_faultin_pfn (98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D=
"69" width=3D"0.3" height=3D"15.0" fill=3D"rgb(250,75,31)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"14.76" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>psi_ta=
sk_switch (1,754,197,263 samples, 0.47%)</title><rect x=3D"770.6" y=3D"1685=
" width=3D"5.6" height=3D"15.0" fill=3D"rgb(206,178,54)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"773.59" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>__wak=
e_up_common_lock (543,525,061 samples, 0.15%)</title><rect x=3D"169.0" y=3D=
"1669" width=3D"1.7" height=3D"15.0" fill=3D"rgb(240,76,51)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"172.00" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>_=
_close (3,024,182,225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"2037" =
width=3D"9.7" height=3D"15.0" fill=3D"rgb(221,6,38)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1177.12" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>get_us=
er_pages_unlocked (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" y=3D=
"261" width=3D"0.9" height=3D"15.0" fill=3D"rgb(210,197,25)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"28.64" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>mt_=
find (440,304,995 samples, 0.12%)</title><rect x=3D"883.8" y=3D"1941" width=
=3D"1.4" height=3D"15.0" fill=3D"rgb(208,44,33)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"886.80" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>get_user_page=
s_unlocked (1,607,674,415 samples, 0.43%)</title><rect x=3D"184.8" y=3D"184=
5" width=3D"5.1" height=3D"15.0" fill=3D"rgb(215,57,38)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"187.75" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>[unkn=
own] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1141" widt=
h=3D"19.2" height=3D"15.0" fill=3D"rgb(209,43,20)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"13.00" y=3D"1151.5" ></text>=0A</g>=0A<g >=0A<title>handle_userf=
ault (2,079,126,509 samples, 0.56%)</title><rect x=3D"100.0" y=3D"1541" wid=
th=3D"6.6" height=3D"15.0" fill=3D"rgb(231,140,27)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"102.98" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_v=
cpu_ioctl_run (2,179,708,244 samples, 0.59%)</title><rect x=3D"121.2" y=3D"=
1829" width=3D"7.0" height=3D"15.0" fill=3D"rgb(210,220,9)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"124.25" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>do=
_fault (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"229" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(213,121,19)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"32.00" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_comm=
on_lock (295,823,689 samples, 0.08%)</title><rect x=3D"84.6" y=3D"1477" wid=
th=3D"1.0" height=3D"15.0" fill=3D"rgb(225,36,36)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"87.63" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>__perf_event=
_task_sched_out (62,840,882 samples, 0.02%)</title><rect x=3D"24.7" y=3D"53=
" width=3D"0.2" height=3D"15.0" fill=3D"rgb(219,218,6)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"27.71" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-inte=
l.ko] (39,704,171 samples, 0.01%)</title><rect x=3D"157.4" y=3D"1829" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(244,8,42)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"160.38" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>xas_descend (1=
09,624,453 samples, 0.03%)</title><rect x=3D"88.4" y=3D"1477" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(243,142,24)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"91.36" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_=
lock_slowpath (760,098,764 samples, 0.21%)</title><rect x=3D"151.7" y=3D"15=
89" width=3D"2.4" height=3D"15.0" fill=3D"rgb(206,5,22)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"154.65" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>secur=
ity_file_permission (359,254,943 samples, 0.10%)</title><rect x=3D"264.6" y=
=3D"1957" width=3D"1.1" height=3D"15.0" fill=3D"rgb(207,169,8)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"267.59" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__x64_sys_ioctl (2,083,270,665 samples, 0.56%)</title><rect x=3D"172.4" y=
=3D"1973" width=3D"6.6" height=3D"15.0" fill=3D"rgb(220,139,42)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"175.40" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<tit=
le>vmx_vcpu_run (351,897,454 samples, 0.10%)</title><rect x=3D"36.5" y=3D"1=
557" width=3D"1.1" height=3D"15.0" fill=3D"rgb(228,162,6)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"39.49" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>[unk=
nown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"837" widt=
h=3D"19.2" height=3D"15.0" fill=3D"rgb(228,218,43)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"13.00" y=3D"847.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6=
,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1413" width=3D"19=
.2" height=3D"15.0" fill=3D"rgb(234,144,32)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"13.00" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (182,03=
7,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"85" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(223,28,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69"=
 y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (810,906,304 samples=
, 0.22%)</title><rect x=3D"128.2" y=3D"1749" width=3D"2.6" height=3D"15.0" =
fill=3D"rgb(227,18,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"175=
9.5" ></text>=0A</g>=0A<g >=0A<title>__fget_light (584,182,411 samples, 0.1=
6%)</title><rect x=3D"447.9" y=3D"1989" width=3D"1.8" height=3D"15.0" fill=
=3D"rgb(239,114,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"450.88" y=3D"1999.5=
" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (2,423,604,255 samples,=
 0.65%)</title><rect x=3D"132.6" y=3D"1701" width=3D"7.7" height=3D"15.0" f=
ill=3D"rgb(254,35,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"1711=
.5" ></text>=0A</g>=0A<g >=0A<title>mtree_range_walk (366,905,616 samples, =
0.10%)</title><rect x=3D"485.9" y=3D"1781" width=3D"1.2" height=3D"15.0" fi=
ll=3D"rgb(224,53,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"488.94" y=3D"1791.=
5" ></text>=0A</g>=0A<g >=0A<title>handle_ept_violation (128,634,108 sample=
s, 0.03%)</title><rect x=3D"460.2" y=3D"1925" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(228,107,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"463.18" y=3D"1=
935.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (123,122,609 sample=
s, 0.03%)</title><rect x=3D"11.4" y=3D"197" width=3D"0.4" height=3D"15.0" f=
ill=3D"rgb(214,116,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"207.=
5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (121,177,915 samples, 0=
.03%)</title><rect x=3D"40.8" y=3D"1349" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(244,59,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"43.82" y=3D"1359.5" =
></text>=0A</g>=0A<g >=0A<title>__get_user_pages (1,118,406,405 samples, 0.=
30%)</title><rect x=3D"68.7" y=3D"1557" width=3D"3.6" height=3D"15.0" fill=
=3D"rgb(213,56,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.70" y=3D"1567.5" =
></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,724,589,751 samp=
les, 0.47%)</title><rect x=3D"173.3" y=3D"1829" width=3D"5.5" height=3D"15.=
0" fill=3D"rgb(233,78,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.30" y=3D"=
1839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (102,868,725,361 sa=
mples, 27.77%)</title><rect x=3D"466.8" y=3D"1893" width=3D"327.7" height=
=3D"15.0" fill=3D"rgb(225,95,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"469.82"=
 y=3D"1903.5" >kvm_faultin_pfn</text>=0A</g>=0A<g >=0A<title>do_raw_spin_un=
lock (44,336,098 samples, 0.01%)</title><rect x=3D"904.0" y=3D"1941" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(225,28,50)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"906.96" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1=
,312,783,414 samples, 0.35%)</title><rect x=3D"167.9" y=3D"1829" width=3D"4=
.2" height=3D"15.0" fill=3D"rgb(239,131,42)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"170.89" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (790,3=
01,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"293" width=3D"2.5" heig=
ht=3D"15.0" fill=3D"rgb(254,149,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.=
48" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,039,298,711 sa=
mples, 1.63%)</title><rect x=3D"10.0" y=3D"549" width=3D"19.2" height=3D"15=
.0" fill=3D"rgb(249,193,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D=
"559.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_load (32,072,084 samples, =
0.01%)</title><rect x=3D"58.3" y=3D"1333" width=3D"0.1" height=3D"15.0" fil=
l=3D"rgb(238,117,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.26" y=3D"1343.5"=
 ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (54,729,582 samp=
les, 0.01%)</title><rect x=3D"704.5" y=3D"1589" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(254,95,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.49" y=3D"=
1599.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (57,379,601 samples,=
 0.02%)</title><rect x=3D"112.7" y=3D"1733" width=3D"0.1" height=3D"15.0" f=
ill=3D"rgb(251,161,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.66" y=3D"174=
3.5" ></text>=0A</g>=0A<g >=0A<title>avc_has_perm (71,054,111 samples, 0.02=
%)</title><rect x=3D"265.1" y=3D"1925" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(220,133,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"268.09" y=3D"1935.5"=
 ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_page_state (308,425,359 sampl=
es, 0.08%)</title><rect x=3D"1179.3" y=3D"1781" width=3D"1.0" height=3D"15.=
0" fill=3D"rgb(254,189,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.35" y=
=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (1,329,332,1=
29 samples, 0.36%)</title><rect x=3D"167.9" y=3D"1877" width=3D"4.2" height=
=3D"15.0" fill=3D"rgb(240,34,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.89"=
 y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (2,179,708,24=
4 samples, 0.59%)</title><rect x=3D"121.2" y=3D"1861" width=3D"7.0" height=
=3D"15.0" fill=3D"rgb(249,114,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.25=
" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,024,160,9=
04 samples, 0.28%)</title><rect x=3D"33.1" y=3D"1445" width=3D"3.3" height=
=3D"15.0" fill=3D"rgb(219,203,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"36.10"=
 y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>percpu_counter_add_batch (66,=
519,254 samples, 0.02%)</title><rect x=3D"889.9" y=3D"1941" width=3D"0.3" h=
eight=3D"15.0" fill=3D"rgb(211,174,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
892.95" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__munmap (1,619,511,00=
8 samples, 0.44%)</title><rect x=3D"1183.8" y=3D"2037" width=3D"5.1" height=
=3D"15.0" fill=3D"rgb(252,3,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.76=
" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (2,491,551,09=
0 samples, 0.67%)</title><rect x=3D"17.2" y=3D"357" width=3D"8.0" height=3D=
"15.0" fill=3D"rgb(225,60,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=
=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>finish_task_switch (194,252,933 =
samples, 0.05%)</title><rect x=3D"83.5" y=3D"1429" width=3D"0.6" height=3D"=
15.0" fill=3D"rgb(239,103,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.48" y=
=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (2,491,551,090 =
samples, 0.67%)</title><rect x=3D"17.2" y=3D"197" width=3D"8.0" height=3D"1=
5.0" fill=3D"rgb(220,89,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D=
"207.5" ></text>=0A</g>=0A<g >=0A<title>tlb_flush_rmaps (376,891,628 sample=
s, 0.10%)</title><rect x=3D"1187.6" y=3D"1877" width=3D"1.2" height=3D"15.0=
" fill=3D"rgb(248,134,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.64" y=3D"=
1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (123,051,561 samples=
, 0.03%)</title><rect x=3D"10.0" y=3D"69" width=3D"0.4" height=3D"15.0" fil=
l=3D"rgb(212,138,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"79.5" =
></text>=0A</g>=0A<g >=0A<title>up_read (105,132,105 samples, 0.03%)</title=
><rect x=3D"782.7" y=3D"1717" width=3D"0.3" height=3D"15.0" fill=3D"rgb(216=
,169,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"785.67" y=3D"1727.5" ></text>=
=0A</g>=0A<g >=0A<title>do_fault (1,075,357,417 samples, 0.29%)</title><rec=
t x=3D"68.8" y=3D"1509" width=3D"3.5" height=3D"15.0" fill=3D"rgb(215,65,19=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.83" y=3D"1519.5" ></text>=0A</g>=
=0A<g >=0A<title>mfill_atomic_install_pte (44,343,974 samples, 0.01%)</titl=
e><rect x=3D"250.5" y=3D"1941" width=3D"0.1" height=3D"15.0" fill=3D"rgb(21=
5,173,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"253.50" y=3D"1951.5" ></text>=
=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,488,009,723 samples, 0.40%)</ti=
tle><rect x=3D"37.7" y=3D"1669" width=3D"4.7" height=3D"15.0" fill=3D"rgb(2=
33,224,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.67" y=3D"1679.5" ></text>=
=0A</g>=0A<g >=0A<title>__wake_up_common (41,998,375 samples, 0.01%)</title=
><rect x=3D"33.2" y=3D"1317" width=3D"0.2" height=3D"15.0" fill=3D"rgb(236,=
176,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"36.25" y=3D"1327.5" ></text>=0A=
</g>=0A<g >=0A<title>kvm_tdp_mmu_map (55,266,319 samples, 0.01%)</title><re=
ct x=3D"84.2" y=3D"1637" width=3D"0.2" height=3D"15.0" fill=3D"rgb(220,109,=
48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.24" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>__mod_memcg_lruvec_state (110,442,706 samples, 0.03%)</tit=
le><rect x=3D"1175.4" y=3D"1813" width=3D"0.4" height=3D"15.0" fill=3D"rgb(=
249,60,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.41" y=3D"1823.5" ></text=
>=0A</g>=0A<g >=0A<title>schedule (40,046,245 samples, 0.01%)</title><rect =
x=3D"31.4" y=3D"1317" width=3D"0.1" height=3D"15.0" fill=3D"rgb(224,213,25)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.41" y=3D"1327.5" ></text>=0A</g>=0A=
<g >=0A<title>__handle_mm_fault (145,741,482 samples, 0.04%)</title><rect x=
=3D"25.2" y=3D"197" width=3D"0.4" height=3D"15.0" fill=3D"rgb(243,128,11)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"207.5" ></text>=0A</g>=0A<g =
>=0A<title>folio_mark_accessed (234,113,139 samples, 0.06%)</title><rect x=
=3D"48.2" y=3D"1525" width=3D"0.8" height=3D"15.0" fill=3D"rgb(205,60,42)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"51.22" y=3D"1535.5" ></text>=0A</g>=0A<g=
 >=0A<title>get_user_pages_fast_only (336,537,251 samples, 0.09%)</title><r=
ect x=3D"158.3" y=3D"1797" width=3D"1.1" height=3D"15.0" fill=3D"rgb(246,32=
,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.30" y=3D"1807.5" ></text>=0A</=
g>=0A<g >=0A<title>__fdget_pos (443,268,542 samples, 0.12%)</title><rect x=
=3D"255.7" y=3D"1973" width=3D"1.4" height=3D"15.0" fill=3D"rgb(205,56,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"258.65" y=3D"1983.5" ></text>=0A</g>=0A=
<g >=0A<title>[unknown] (5,173,433,181 samples, 1.40%)</title><rect x=3D"10=
.0" y=3D"469" width=3D"16.5" height=3D"15.0" fill=3D"rgb(234,153,19)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<=
title>perf_pmu_disable (32,541,144 samples, 0.01%)</title><rect x=3D"744.8"=
 y=3D"1669" width=3D"0.1" height=3D"15.0" fill=3D"rgb(229,165,38)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"747.75" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__schedule (44,076,692 samples, 0.01%)</title><rect x=3D"178.7" y=3D"1=
669" width=3D"0.1" height=3D"15.0" fill=3D"rgb(240,100,2)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"181.65" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>han=
dle_mm_fault (182,037,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"133"=
 width=3D"0.6" height=3D"15.0" fill=3D"rgb(208,121,40)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"15.69" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_re=
ad_unlock (44,193,058 samples, 0.01%)</title><rect x=3D"1180.3" y=3D"1781" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(220,207,27)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1183.33" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__hand=
le_mm_fault (2,165,906,632 samples, 0.58%)</title><rect x=3D"148.6" y=3D"17=
33" width=3D"6.9" height=3D"15.0" fill=3D"rgb(253,151,52)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"151.58" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>__c=
ount_memcg_events (196,324,174 samples, 0.05%)</title><rect x=3D"73.1" y=3D=
"1541" width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,70,7)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"76.06" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>[un=
known] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1189" wi=
dth=3D"19.2" height=3D"15.0" fill=3D"rgb(205,159,50)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"1199.5" ></text>=0A</g>=0A<g >=0A<title>native_q=
ueued_spin_lock_slowpath (326,417,562 samples, 0.09%)</title><rect x=3D"110=
.2" y=3D"1493" width=3D"1.1" height=3D"15.0" fill=3D"rgb(238,158,23)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"113.22" y=3D"1503.5" ></text>=0A</g>=0A<g >=
=0A<title>__filemap_get_folio (130,134,678 samples, 0.04%)</title><rect x=
=3D"42.9" y=3D"1381" width=3D"0.4" height=3D"15.0" fill=3D"rgb(245,42,17)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.86" y=3D"1391.5" ></text>=0A</g>=0A<g=
 >=0A<title>[kvm-intel.ko] (131,427,223 samples, 0.04%)</title><rect x=3D"9=
2.8" y=3D"1701" width=3D"0.5" height=3D"15.0" fill=3D"rgb(240,209,42)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"95.83" y=3D"1711.5" ></text>=0A</g>=0A<g >=
=0A<title>entry_SYSCALL_64 (2,913,335,273 samples, 0.79%)</title><rect x=3D=
"158.2" y=3D"1973" width=3D"9.3" height=3D"15.0" fill=3D"rgb(223,43,22)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"161.22" y=3D"1983.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (443,292,323 samples, 0.12%)</title><rect x=3D"=
224.7" y=3D"1909" width=3D"1.4" height=3D"15.0" fill=3D"rgb(244,180,9)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"227.68" y=3D"1919.5" ></text>=0A</g>=0A<g =
>=0A<title>vmx_handle_exit (790,301,371 samples, 0.21%)</title><rect x=3D"2=
6.5" y=3D"357" width=3D"2.5" height=3D"15.0" fill=3D"rgb(253,31,10)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__hrtimer_run_queues (160,833,494 samples, 0.04%)</title><rect x=3D"83=
4.2" y=3D"1845" width=3D"0.5" height=3D"15.0" fill=3D"rgb(245,71,19)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1855.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_pfn_to_refcounted_page (868,067,535 samples, 0.23%)</title><r=
ect x=3D"808.4" y=3D"1877" width=3D"2.7" height=3D"15.0" fill=3D"rgb(208,97=
,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"811.37" y=3D"1887.5" ></text>=0A</=
g>=0A<g >=0A<title>__GI___ioctl (1,603,422,188 samples, 0.43%)</title><rect=
 x=3D"54.0" y=3D"1733" width=3D"5.1" height=3D"15.0" fill=3D"rgb(237,61,27)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.96" y=3D"1743.5" ></text>=0A</g>=0A=
<g >=0A<title>get_user_pages_unlocked (182,037,942 samples, 0.05%)</title><=
rect x=3D"12.7" y=3D"165" width=3D"0.6" height=3D"15.0" fill=3D"rgb(228,54,=
27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"175.5" ></text>=0A</g>=
=0A<g >=0A<title>shmem_get_folio_gfp (1,293,336,492 samples, 0.35%)</title>=
<rect x=3D"185.8" y=3D"1733" width=3D"4.1" height=3D"15.0" fill=3D"rgb(229,=
47,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.75" y=3D"1743.5" ></text>=0A=
</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect =
x=3D"10.0" y=3D"693" width=3D"19.2" height=3D"15.0" fill=3D"rgb(209,143,47)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"703.5" ></text>=0A</g>=0A<=
g >=0A<title>clock_gettime@GLIBC_2.2.5 (506,654,606 samples, 0.14%)</title>=
<rect x=3D"434.1" y=3D"2037" width=3D"1.6" height=3D"15.0" fill=3D"rgb(239,=
226,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"437.12" y=3D"2047.5" ></text>=0A=
</g>=0A<g >=0A<title>rcu_qs (462,526,065 samples, 0.12%)</title><rect x=3D"=
777.1" y=3D"1669" width=3D"1.4" height=3D"15.0" fill=3D"rgb(232,133,4)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"780.08" y=3D"1679.5" ></text>=0A</g>=0A<g =
>=0A<title>__x64_sys_ioctl (1,657,361,967 samples, 0.45%)</title><rect x=3D=
"93.4" y=3D"1797" width=3D"5.3" height=3D"15.0" fill=3D"rgb(244,99,45)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"96.39" y=3D"1807.5" ></text>=0A</g>=0A<g >=
=0A<title>__mod_node_page_state (88,335,712 samples, 0.02%)</title><rect x=
=3D"1175.1" y=3D"1797" width=3D"0.3" height=3D"15.0" fill=3D"rgb(250,20,44)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.13" y=3D"1807.5" ></text>=0A</g>=
=0A<g >=0A<title>native_queued_spin_lock_slowpath (1,187,074,108 samples, 0=
.32%)</title><rect x=3D"122.7" y=3D"1525" width=3D"3.8" height=3D"15.0" fil=
l=3D"rgb(213,190,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.74" y=3D"1535.=
5" ></text>=0A</g>=0A<g >=0A<title>nohz_balance_exit_idle (219,093,086 samp=
les, 0.06%)</title><rect x=3D"782.0" y=3D"1541" width=3D"0.7" height=3D"15.=
0" fill=3D"rgb(249,80,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=3D"=
1551.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (61,059,836 samples,=
 0.02%)</title><rect x=3D"58.9" y=3D"1605" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(209,57,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.87" y=3D"1615.5=
" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (1,326,971,558 samples, 0.3=
6%)</title><rect x=3D"108.6" y=3D"1845" width=3D"4.2" height=3D"15.0" fill=
=3D"rgb(212,55,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.62" y=3D"1855.5"=
 ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (825,879,=
574 samples, 0.22%)</title><rect x=3D"55.2" y=3D"1349" width=3D"2.6" height=
=3D"15.0" fill=3D"rgb(245,33,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"58.22"=
 y=3D"1359.5" ></text>=0A</g>=0A<g >=0A<title>truncate_inode_folio (1,626,9=
35,710 samples, 0.44%)</title><rect x=3D"1178.6" y=3D"1845" width=3D"5.2" h=
eight=3D"15.0" fill=3D"rgb(220,41,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
81.57" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,091,339,8=
08 samples, 0.29%)</title><rect x=3D"109.1" y=3D"1605" width=3D"3.5" height=
=3D"15.0" fill=3D"rgb(210,70,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.13=
" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (160,833,49=
4 samples, 0.04%)</title><rect x=3D"834.2" y=3D"1829" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(244,156,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.1=
8" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>kvm_unmap_gfn_range (132,95=
9,376 samples, 0.04%)</title><rect x=3D"1170.9" y=3D"1877" width=3D"0.4" he=
ight=3D"15.0" fill=3D"rgb(215,102,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
173.87" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (214,9=
20,756 samples, 0.06%)</title><rect x=3D"25.6" y=3D"53" width=3D"0.7" heigh=
t=3D"15.0" fill=3D"rgb(213,46,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64=
" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (47,348,631 =
samples, 0.01%)</title><rect x=3D"706.7" y=3D"1669" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(210,149,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.65" =
y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (964,889,646 =
samples, 0.26%)</title><rect x=3D"169.0" y=3D"1685" width=3D"3.1" height=3D=
"15.0" fill=3D"rgb(219,222,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"172.00" =
y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (3,0=
24,182,225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"1989" width=3D"9.=
7" height=3D"15.0" fill=3D"rgb(232,31,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1177.12" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,=
654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"933" width=3D"19.2" he=
ight=3D"15.0" fill=3D"rgb(241,23,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
.00" y=3D"943.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (24,536,252,215 =
samples, 6.62%)</title><rect x=3D"10.0" y=3D"1829" width=3D"78.2" height=3D=
"15.0" fill=3D"rgb(226,100,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"1839.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>hva_to_pfn (264,013,79=
2 samples, 0.07%)</title><rect x=3D"25.6" y=3D"277" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(220,192,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=
=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath=
 (3,491,964,277 samples, 0.94%)</title><rect x=3D"819.1" y=3D"1877" width=
=3D"11.1" height=3D"15.0" fill=3D"rgb(249,80,25)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"822.12" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__mem_cgroup=
_uncharge_list (65,784,851 samples, 0.02%)</title><rect x=3D"1174.8" y=3D"1=
813" width=3D"0.3" height=3D"15.0" fill=3D"rgb(219,192,11)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"1177.85" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>k=
vm_tdp_page_fault (1,088,324,720 samples, 0.29%)</title><rect x=3D"84.5" y=
=3D"1669" width=3D"3.5" height=3D"15.0" fill=3D"rgb(222,2,4)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"87.52" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title=
>load_balance (54,093,156 samples, 0.01%)</title><rect x=3D"29.0" y=3D"85" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(237,204,22)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"32.02" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_v=
cpu_load (1,905,016,498 samples, 0.51%)</title><rect x=3D"760.0" y=3D"1669"=
 width=3D"6.1" height=3D"15.0" fill=3D"rgb(225,2,45)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"763.04" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>shmem_f=
ault (1,236,031,354 samples, 0.33%)</title><rect x=3D"88.4" y=3D"1541" widt=
h=3D"3.9" height=3D"15.0" fill=3D"rgb(219,103,7)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"91.36" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>intel_guest_g=
et_msrs (119,054,615 samples, 0.03%)</title><rect x=3D"871.2" y=3D"1925" wi=
dth=3D"0.4" height=3D"15.0" fill=3D"rgb(220,27,38)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"874.21" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter=
_guest (2,305,263,281 samples, 0.62%)</title><rect x=3D"42.4" y=3D"1605" wi=
dth=3D"7.4" height=3D"15.0" fill=3D"rgb(226,31,45)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"45.41" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (=
6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"821" width=3D"19=
.2" height=3D"15.0" fill=3D"rgb(227,217,44)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"13.00" y=3D"831.5" ></text>=0A</g>=0A<g >=0A<title>workingset_activati=
on (1,508,251,130 samples, 0.41%)</title><rect x=3D"803.6" y=3D"1861" width=
=3D"4.8" height=3D"15.0" fill=3D"rgb(205,9,46)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"806.56" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock=
_irqsave (642,869,436 samples, 0.17%)</title><rect x=3D"215.3" y=3D"1877" w=
idth=3D"2.0" height=3D"15.0" fill=3D"rgb(231,166,26)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"218.30" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__x64_s=
ys_ioctl (1,319,411,362 samples, 0.36%)</title><rect x=3D"49.8" y=3D"1669" =
width=3D"4.2" height=3D"15.0" fill=3D"rgb(208,192,41)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"52.75" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_ent=
er_guest (98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D"133" widt=
h=3D"0.3" height=3D"15.0" fill=3D"rgb(241,90,41)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"14.76" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock=
_irqsave (2,344,242,284 samples, 0.63%)</title><rect x=3D"17.2" y=3D"69" wi=
dth=3D"7.5" height=3D"15.0" fill=3D"rgb(238,179,50)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"20.24" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSC=
ALL_64 (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" y=3D"437" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(220,148,36)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"28.64" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,0=
40,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1301" width=3D"19.2=
" height=3D"15.0" fill=3D"rgb(209,109,7)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_i=
nterrupt (47,348,631 samples, 0.01%)</title><rect x=3D"706.7" y=3D"1701" wi=
dth=3D"0.1" height=3D"15.0" fill=3D"rgb(230,33,33)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"709.65" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spi=
n_lock (165,602,732 samples, 0.04%)</title><rect x=3D"65.7" y=3D"1413" widt=
h=3D"0.5" height=3D"15.0" fill=3D"rgb(231,217,52)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"68.70" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_g=
uest (1,850,870,166 samples, 0.50%)</title><rect x=3D"184.1" y=3D"1941" wid=
th=3D"5.9" height=3D"15.0" fill=3D"rgb(245,107,18)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"187.13" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] =
(2,272,126,817 samples, 0.61%)</title><rect x=3D"10.0" y=3D"421" width=3D"7=
.2" height=3D"15.0" fill=3D"rgb(205,79,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_=
run (1,655,662,953 samples, 0.45%)</title><rect x=3D"142.3" y=3D"1877" widt=
h=3D"5.2" height=3D"15.0" fill=3D"rgb(218,133,7)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"145.27" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (1=
23,051,561 samples, 0.03%)</title><rect x=3D"10.0" y=3D"165" width=3D"0.4" =
height=3D"15.0" fill=3D"rgb(227,124,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
13.00" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,024=
,160,904 samples, 0.28%)</title><rect x=3D"33.1" y=3D"1429" width=3D"3.3" h=
eight=3D"15.0" fill=3D"rgb(212,90,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"3=
6.10" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (176,966,80=
4 samples, 0.05%)</title><rect x=3D"92.8" y=3D"1717" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(216,84,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"95.75" =
y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>kvm_is_mmio_pfn (36,440,925 sa=
mples, 0.01%)</title><rect x=3D"84.3" y=3D"1605" width=3D"0.1" height=3D"15=
.0" fill=3D"rgb(216,201,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.30" y=3D=
"1615.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (252,262,419 samples,=
 0.07%)</title><rect x=3D"166.7" y=3D"1877" width=3D"0.8" height=3D"15.0" f=
ill=3D"rgb(215,125,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"169.69" y=3D"188=
7.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_load (322,520,962 samples, 0.=
09%)</title><rect x=3D"105.0" y=3D"1461" width=3D"1.0" height=3D"15.0" fill=
=3D"rgb(232,185,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"108.02" y=3D"1471.5=
" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (470,679,882 samples, 0.=
13%)</title><rect x=3D"89.6" y=3D"1493" width=3D"1.5" height=3D"15.0" fill=
=3D"rgb(231,145,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"92.56" y=3D"1503.5" =
></text>=0A</g>=0A<g >=0A<title>tdp_mmu_zap_leafs (88,418,539 samples, 0.02=
%)</title><rect x=3D"897.1" y=3D"1845" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(240,21,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"1855.5" =
></text>=0A</g>=0A<g >=0A<title>__put_user_8 (66,506,996 samples, 0.02%)</t=
itle><rect x=3D"193.1" y=3D"1957" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(245,185,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"196.09" y=3D"1967.5" ></te=
xt>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (36,127,222 samples, 0.01%)</titl=
e><rect x=3D"31.8" y=3D"1525" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218=
,90,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"34.84" y=3D"1535.5" ></text>=0A=
</g>=0A<g >=0A<title>select_task_rq_fair (531,947,254 samples, 0.14%)</titl=
e><rect x=3D"217.9" y=3D"1877" width=3D"1.7" height=3D"15.0" fill=3D"rgb(24=
1,138,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"220.91" y=3D"1887.5" ></text>=
=0A</g>=0A<g >=0A<title>internal_get_user_pages_fast (144,445,061 samples, =
0.04%)</title><rect x=3D"68.2" y=3D"1557" width=3D"0.5" height=3D"15.0" fil=
l=3D"rgb(215,64,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1567.5"=
 ></text>=0A</g>=0A<g >=0A<title>[unknown] (26,153,017,361 samples, 7.06%)<=
/title><rect x=3D"10.0" y=3D"1845" width=3D"83.3" height=3D"15.0" fill=3D"r=
gb(231,70,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1855.5" >[unk=
nown]</text>=0A</g>=0A<g >=0A<title>__do_fault (1,381,981,405 samples, 0.37=
%)</title><rect x=3D"93.9" y=3D"1573" width=3D"4.4" height=3D"15.0" fill=3D=
"rgb(218,20,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.91" y=3D"1583.5" ></=
text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (644,922,204 samples, 0.17%)=
</title><rect x=3D"29.5" y=3D"1413" width=3D"2.0" height=3D"15.0" fill=3D"r=
gb(244,131,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.48" y=3D"1423.5" ></t=
ext>=0A</g>=0A<g >=0A<title>vmx_vcpu_load (130,223,631 samples, 0.04%)</tit=
le><rect x=3D"35.8" y=3D"1269" width=3D"0.4" height=3D"15.0" fill=3D"rgb(23=
0,74,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.82" y=3D"1279.5" ></text>=
=0A</g>=0A<g >=0A<title>finish_task_switch (131,759,290 samples, 0.04%)</ti=
tle><rect x=3D"35.8" y=3D"1301" width=3D"0.4" height=3D"15.0" fill=3D"rgb(2=
06,50,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.81" y=3D"1311.5" ></text>=
=0A</g>=0A<g >=0A<title>__perf_event_task_sched_in (668,687,078 samples, 0.=
18%)</title><rect x=3D"757.5" y=3D"1669" width=3D"2.2" height=3D"15.0" fill=
=3D"rgb(223,207,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"760.54" y=3D"1679.5=
" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (2,549,679,159 sa=
mples, 0.69%)</title><rect x=3D"59.8" y=3D"1669" width=3D"8.1" height=3D"15=
.0" fill=3D"rgb(233,46,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.80" y=3D"=
1679.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (5=
26,024,177 samples, 0.14%)</title><rect x=3D"94.8" y=3D"1461" width=3D"1.7"=
 height=3D"15.0" fill=3D"rgb(243,35,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"97.84" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_state (86=
,225,109 samples, 0.02%)</title><rect x=3D"802.1" y=3D"1813" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(241,2,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"8=
05.13" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>task_work_run (41,394,8=
96 samples, 0.01%)</title><rect x=3D"875.4" y=3D"1941" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(222,76,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"878.39"=
 y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,142,740,43=
4 samples, 0.31%)</title><rect x=3D"109.0" y=3D"1765" width=3D"3.7" height=
=3D"15.0" fill=3D"rgb(254,150,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.0=
2" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (2,165,906,632 s=
amples, 0.58%)</title><rect x=3D"148.6" y=3D"1701" width=3D"6.9" height=3D"=
15.0" fill=3D"rgb(243,24,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"151.58" y=
=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (68,495,474 samples,=
 0.02%)</title><rect x=3D"66.2" y=3D"1397" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(231,103,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"69.23" y=3D"1407.=
5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)=
</title><rect x=3D"10.0" y=3D"645" width=3D"19.2" height=3D"15.0" fill=3D"r=
gb(252,158,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"655.5" ></te=
xt>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (2,305,287,529 samples, 0.62%)<=
/title><rect x=3D"42.4" y=3D"1685" width=3D"7.4" height=3D"15.0" fill=3D"rg=
b(219,79,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1695.5" ></tex=
t>=0A</g>=0A<g >=0A<title>kvm_release_page_clean (309,327,693 samples, 0.08=
%)</title><rect x=3D"156.3" y=3D"1813" width=3D"1.0" height=3D"15.0" fill=
=3D"rgb(239,66,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"159.29" y=3D"1823.5"=
 ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (80,050,831 sa=
mples, 0.02%)</title><rect x=3D"759.7" y=3D"1653" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(239,223,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"762.74" y=
=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>up_read (370,571,713 samples, 0=
.10%)</title><rect x=3D"154.3" y=3D"1637" width=3D"1.2" height=3D"15.0" fil=
l=3D"rgb(220,193,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"157.30" y=3D"1647.=
5" ></text>=0A</g>=0A<g >=0A<title>load_balance (341,531,787 samples, 0.09%=
)</title><rect x=3D"769.2" y=3D"1653" width=3D"1.0" height=3D"15.0" fill=3D=
"rgb(212,79,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"772.16" y=3D"1663.5" ><=
/text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (2,165,906,632 samples, 0=
.58%)</title><rect x=3D"148.6" y=3D"1669" width=3D"6.9" height=3D"15.0" fil=
l=3D"rgb(218,181,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"151.58" y=3D"1679.=
5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (3,024,182,225 samples,=
 0.82%)</title><rect x=3D"1174.1" y=3D"2021" width=3D"9.7" height=3D"15.0" =
fill=3D"rgb(250,129,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.12" y=3D"2=
031.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (419,714,658 s=
amples, 0.11%)</title><rect x=3D"29.5" y=3D"1317" width=3D"1.4" height=3D"1=
5.0" fill=3D"rgb(248,206,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.54" y=3D=
"1327.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (155,138,716 sam=
ples, 0.04%)</title><rect x=3D"274.0" y=3D"1877" width=3D"0.5" height=3D"15=
.0" fill=3D"rgb(218,64,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"276.99" y=3D=
"1887.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (2,131,350,080 samples,=
 0.58%)</title><rect x=3D"112.9" y=3D"1717" width=3D"6.7" height=3D"15.0" f=
ill=3D"rgb(219,28,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1727=
.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (2,114,461,488 samples, =
0.57%)</title><rect x=3D"440.3" y=3D"2037" width=3D"6.8" height=3D"15.0" fi=
ll=3D"rgb(221,38,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.33" y=3D"2047.=
5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,143,809,245 samples,=
 0.31%)</title><rect x=3D"84.5" y=3D"1717" width=3D"3.7" height=3D"15.0" fi=
ll=3D"rgb(237,175,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"1727.=
5" ></text>=0A</g>=0A<g >=0A<title>update_process_times (160,833,494 sample=
s, 0.04%)</title><rect x=3D"834.2" y=3D"1797" width=3D"0.5" height=3D"15.0"=
 fill=3D"rgb(227,37,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"18=
07.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,075,357,417 sa=
mples, 0.29%)</title><rect x=3D"68.8" y=3D"1461" width=3D"3.5" height=3D"15=
.0" fill=3D"rgb(225,6,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.83" y=3D"1=
471.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,473,606,899 samples, 0=
.40%)</title><rect x=3D"61.8" y=3D"1477" width=3D"4.6" height=3D"15.0" fill=
=3D"rgb(253,102,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.75" y=3D"1487.5"=
 ></text>=0A</g>=0A<g >=0A<title>psi_group_change (1,422,386,957 samples, 0=
.38%)</title><rect x=3D"771.3" y=3D"1669" width=3D"4.5" height=3D"15.0" fil=
l=3D"rgb(247,137,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"774.27" y=3D"1679.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_map (279,557,039 samples, 0.=
08%)</title><rect x=3D"78.8" y=3D"1621" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(245,200,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"81.75" y=3D"1631.5"=
 ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (159,314,940 samples, 0.04%=
)</title><rect x=3D"10.8" y=3D"53" width=3D"0.5" height=3D"15.0" fill=3D"rg=
b(231,14,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"63.5" ></text>=
=0A</g>=0A<g >=0A<title>update_min_vruntime (257,735,663 samples, 0.07%)</t=
itle><rect x=3D"753.0" y=3D"1637" width=3D"0.8" height=3D"15.0" fill=3D"rgb=
(253,57,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"755.99" y=3D"1647.5" ></tex=
t>=0A</g>=0A<g >=0A<title>handle_userfault (1,678,566,158 samples, 0.45%)</=
title><rect x=3D"173.4" y=3D"1701" width=3D"5.4" height=3D"15.0" fill=3D"rg=
b(216,45,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.45" y=3D"1711.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,226,612,664 samples, 0.33%=
)</title><rect x=3D"55.0" y=3D"1589" width=3D"3.9" height=3D"15.0" fill=3D"=
rgb(229,6,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.96" y=3D"1599.5" ></tex=
t>=0A</g>=0A<g >=0A<title>tick_sched_timer (155,141,069 samples, 0.04%)</ti=
tle><rect x=3D"1032.4" y=3D"1861" width=3D"0.5" height=3D"15.0" fill=3D"rgb=
(233,21,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.43" y=3D"1871.5" ></tex=
t>=0A</g>=0A<g >=0A<title>[unknown] (43,175,367,632 samples, 11.66%)</title=
><rect x=3D"10.0" y=3D"1973" width=3D"137.5" height=3D"15.0" fill=3D"rgb(25=
0,212,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1983.5" >[unknown=
]</text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (269,433,971 =
samples, 0.07%)</title><rect x=3D"262.3" y=3D"1925" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(250,140,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31" =
y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>follow_page_pte (259,024,777 s=
amples, 0.07%)</title><rect x=3D"121.4" y=3D"1685" width=3D"0.8" height=3D"=
15.0" fill=3D"rgb(221,183,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.39" y=
=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>__libc_read (244,924,162 sample=
s, 0.07%)</title><rect x=3D"896.6" y=3D"2053" width=3D"0.8" height=3D"15.0"=
 fill=3D"rgb(238,31,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"899.62" y=3D"20=
63.5" ></text>=0A</g>=0A<g >=0A<title>shmem_evict_inode (3,024,182,225 samp=
les, 0.82%)</title><rect x=3D"1174.1" y=3D"1893" width=3D"9.7" height=3D"15=
.0" fill=3D"rgb(232,38,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.12" y=
=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (2,632,189,638 =
samples, 0.71%)</title><rect x=3D"158.3" y=3D"1877" width=3D"8.4" height=3D=
"15.0" fill=3D"rgb(251,41,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.30" y=
=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (1,655,662,953 sam=
ples, 0.45%)</title><rect x=3D"142.3" y=3D"1957" width=3D"5.2" height=3D"15=
.0" fill=3D"rgb(214,112,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"145.27" y=
=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpat=
h (184,955,698 samples, 0.05%)</title><rect x=3D"89.0" y=3D"1445" width=3D"=
0.6" height=3D"15.0" fill=3D"rgb(247,185,47)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"91.97" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (3,0=
63,052,576 samples, 0.83%)</title><rect x=3D"132.5" y=3D"1941" width=3D"9.8=
" height=3D"15.0" fill=3D"rgb(237,109,23)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"135.52" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (102,20=
2,941,887 samples, 27.59%)</title><rect x=3D"468.0" y=3D"1877" width=3D"325=
.6" height=3D"15.0" fill=3D"rgb(247,145,29)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"470.98" y=3D"1887.5" >hva_to_pfn</text>=0A</g>=0A<g >=0A<title>kvm_arc=
h_vcpu_load (345,700,992 samples, 0.09%)</title><rect x=3D"104.9" y=3D"1477=
" width=3D"1.1" height=3D"15.0" fill=3D"rgb(231,224,12)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"107.94" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>kvm_v=
cpu_ioctl (2,913,335,273 samples, 0.79%)</title><rect x=3D"158.2" y=3D"1925=
" width=3D"9.3" height=3D"15.0" fill=3D"rgb(218,50,13)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"161.22" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>kvm_fa=
ultin_pfn (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"85" widt=
h=3D"0.3" height=3D"15.0" fill=3D"rgb(210,37,54)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"15.08" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>follow_page_mas=
k (36,260,614 samples, 0.01%)</title><rect x=3D"33.0" y=3D"1445" width=3D"0=
.1" height=3D"15.0" fill=3D"rgb(220,43,50)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"35.98" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (1=
94,252,933 samples, 0.05%)</title><rect x=3D"83.5" y=3D"1397" width=3D"0.6"=
 height=3D"15.0" fill=3D"rgb(208,103,35)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"86.48" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (41,519,7=
04,679 samples, 11.21%)</title><rect x=3D"10.0" y=3D"1957" width=3D"132.3" =
height=3D"15.0" fill=3D"rgb(229,117,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"13.00" y=3D"1967.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>vcpu_enter_gu=
est (182,037,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"261" width=3D=
"0.6" height=3D"15.0" fill=3D"rgb(205,90,42)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"15.69" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>try_grab_folio (14=
8,226,640 samples, 0.04%)</title><rect x=3D"49.8" y=3D"1477" width=3D"0.5" =
height=3D"15.0" fill=3D"rgb(213,43,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
52.80" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_map (54,392=
,863 samples, 0.01%)</title><rect x=3D"130.8" y=3D"1765" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(233,2,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.7=
8" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slo=
wpath (1,896,941,608 samples, 0.51%)</title><rect x=3D"113.3" y=3D"1509" wi=
dth=3D"6.1" height=3D"15.0" fill=3D"rgb(212,63,32)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"116.35" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>update_pro=
cess_times (269,433,971 samples, 0.07%)</title><rect x=3D"262.3" y=3D"1845"=
 width=3D"0.9" height=3D"15.0" fill=3D"rgb(235,223,45)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"265.31" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>handle=
_userfault (1,280,644,704 samples, 0.35%)</title><rect x=3D"185.8" y=3D"171=
7" width=3D"4.1" height=3D"15.0" fill=3D"rgb(205,229,27)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"188.79" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>perf=
_event_task_tick (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D=
"1381" width=3D"0.6" height=3D"15.0" fill=3D"rgb(241,16,19)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"114.26" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>_=
_wake_up_common (39,238,219 samples, 0.01%)</title><rect x=3D"29.5" y=3D"13=
01" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,73,45)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"32.54" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A<title>kvm_f=
aultin_pfn (1,575,061,618 samples, 0.43%)</title><rect x=3D"93.4" y=3D"1685=
" width=3D"5.0" height=3D"15.0" fill=3D"rgb(234,188,15)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"96.41" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>try_to=
_wake_up (2,668,152,464 samples, 0.72%)</title><rect x=3D"528.8" y=3D"1669"=
 width=3D"8.5" height=3D"15.0" fill=3D"rgb(209,169,31)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"531.76" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>preemp=
t_count_add (111,197,530 samples, 0.03%)</title><rect x=3D"1030.1" y=3D"192=
5" width=3D"0.4" height=3D"15.0" fill=3D"rgb(228,8,54)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1033.15" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>__han=
dle_mm_fault (133,987,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"165"=
 width=3D"0.4" height=3D"15.0" fill=3D"rgb(210,39,35)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"19.81" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>native_qu=
eued_spin_lock_slowpath (663,211,659 samples, 0.18%)</title><rect x=3D"69.0=
" y=3D"1381" width=3D"2.1" height=3D"15.0" fill=3D"rgb(250,115,28)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"71.99" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__wake_up_common_lock (579,362,165 samples, 0.16%)</title><rect x=3D"4=
4.2" y=3D"1365" width=3D"1.9" height=3D"15.0" fill=3D"rgb(239,32,34)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"47.23" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A=
<title>handle_userfault (1,352,800,841 samples, 0.37%)</title><rect x=3D"94=
.0" y=3D"1525" width=3D"4.3" height=3D"15.0" fill=3D"rgb(236,107,14)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"97.00" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A=
<title>schedule (42,771,079 samples, 0.01%)</title><rect x=3D"126.9" y=3D"1=
573" width=3D"0.2" height=3D"15.0" fill=3D"rgb(222,15,3)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"129.93" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>kvm_=
arch_vcpu_ioctl_run (1,539,194,524 samples, 0.42%)</title><rect x=3D"167.5"=
 y=3D"1925" width=3D"4.9" height=3D"15.0" fill=3D"rgb(243,135,13)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"170.50" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<t=
itle>native_queued_spin_lock_slowpath (75,995,114 samples, 0.02%)</title><r=
ect x=3D"96.5" y=3D"1493" width=3D"0.3" height=3D"15.0" fill=3D"rgb(243,200=
,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"99.51" y=3D"1503.5" ></text>=0A</g=
>=0A<g >=0A<title>exit_to_user_mode_prepare (3,024,182,225 samples, 0.82%)<=
/title><rect x=3D"1174.1" y=3D"1973" width=3D"9.7" height=3D"15.0" fill=3D"=
rgb(254,114,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.12" y=3D"1983.5" >=
</text>=0A</g>=0A<g >=0A<title>update_load_avg (565,844,356 samples, 0.15%)=
</title><rect x=3D"753.8" y=3D"1653" width=3D"1.8" height=3D"15.0" fill=3D"=
rgb(248,100,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"756.81" y=3D"1663.5" ><=
/text>=0A</g>=0A<g >=0A<title>gup_pgd_range (3,873,226,211 samples, 1.05%)<=
/title><rect x=3D"470.4" y=3D"1829" width=3D"12.3" height=3D"15.0" fill=3D"=
rgb(231,213,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"473.39" y=3D"1839.5" ><=
/text>=0A</g>=0A<g >=0A<title>handle_userfault (1,061,699,118 samples, 0.29=
%)</title><rect x=3D"13.4" y=3D"69" width=3D"3.4" height=3D"15.0" fill=3D"r=
gb(241,102,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.43" y=3D"79.5" ></text=
>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,473,606,899 samples, 0.40%)=
</title><rect x=3D"61.8" y=3D"1445" width=3D"4.6" height=3D"15.0" fill=3D"r=
gb(237,174,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.75" y=3D"1455.5" ></t=
ext>=0A</g>=0A<g >=0A<title>schedule (12,838,899,520 samples, 3.47%)</title=
><rect x=3D"741.8" y=3D"1717" width=3D"40.9" height=3D"15.0" fill=3D"rgb(24=
2,201,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"744.77" y=3D"1727.5" >sch..</=
text>=0A</g>=0A<g >=0A<title>finish_task_switch (35,755,492 samples, 0.01%)=
</title><rect x=3D"119.5" y=3D"1525" width=3D"0.1" height=3D"15.0" fill=3D"=
rgb(205,184,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"122.47" y=3D"1535.5" ><=
/text>=0A</g>=0A<g >=0A<title>native_write_msr (37,050,766 samples, 0.01%)<=
/title><rect x=3D"32.0" y=3D"1525" width=3D"0.1" height=3D"15.0" fill=3D"rg=
b(231,130,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.03" y=3D"1535.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__do_fault (1,112,111,832 samples, 0.30%)</title>=
<rect x=3D"168.5" y=3D"1733" width=3D"3.6" height=3D"15.0" fill=3D"rgb(215,=
194,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.53" y=3D"1743.5" ></text>=0A=
</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,590,623,571 samples, 0.43%)</title><=
rect x=3D"54.0" y=3D"1669" width=3D"5.1" height=3D"15.0" fill=3D"rgb(233,90=
,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=3D"1679.5" ></text>=0A</g=
>=0A<g >=0A<title>xas_init_marks (502,163,359 samples, 0.14%)</title><rect =
x=3D"1180.5" y=3D"1797" width=3D"1.6" height=3D"15.0" fill=3D"rgb(213,195,2=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.47" y=3D"1807.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_vcpu_ioctl (2,305,287,529 samples, 0.62%)</title><rect=
 x=3D"42.4" y=3D"1637" width=3D"7.4" height=3D"15.0" fill=3D"rgb(245,221,33=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>set_next_task_idle (126,773,385 samples, 0.03%)</title><re=
ct x=3D"25.2" y=3D"53" width=3D"0.4" height=3D"15.0" fill=3D"rgb(211,14,6)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.24" y=3D"63.5" ></text>=0A</g>=0A<g =
>=0A<title>rcu_preempt_deferred_qs (59,496,610 samples, 0.02%)</title><rect=
 x=3D"869.1" y=3D"1893" width=3D"0.2" height=3D"15.0" fill=3D"rgb(227,224,4=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"872.12" y=3D"1903.5" ></text>=0A</g>=
=0A<g >=0A<title>__pollwait (44,333,668 samples, 0.01%)</title><rect x=3D"1=
032.1" y=3D"1957" width=3D"0.2" height=3D"15.0" fill=3D"rgb(232,212,53)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1035.14" y=3D"1967.5" ></text>=0A</g>=0A<g=
 >=0A<title>shmem_fault (61,757,117 samples, 0.02%)</title><rect x=3D"29.0"=
 y=3D"197" width=3D"0.2" height=3D"15.0" fill=3D"rgb(247,47,41)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"32.00" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title=
>do_raw_spin_unlock (44,323,767 samples, 0.01%)</title><rect x=3D"273.5" y=
=3D"1925" width=3D"0.1" height=3D"15.0" fill=3D"rgb(242,64,40)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"276.49" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_raw_spin_lock (109,239,051 samples, 0.03%)</title><rect x=3D"28.7" y=
=3D"37" width=3D"0.3" height=3D"15.0" fill=3D"rgb(206,86,11)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"31.65" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>u=
pdate_process_times (110,812,663 samples, 0.03%)</title><rect x=3D"274.0" y=
=3D"1813" width=3D"0.3" height=3D"15.0" fill=3D"rgb(247,84,36)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"276.99" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<titl=
e>[kvm-intel.ko] (315,491,762 samples, 0.09%)</title><rect x=3D"131.5" y=3D=
"1781" width=3D"1.0" height=3D"15.0" fill=3D"rgb(236,201,24)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"134.51" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<titl=
e>handle_userfault (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" y=
=3D"133" width=3D"0.9" height=3D"15.0" fill=3D"rgb(213,163,13)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"28.64" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>=
trigger_load_balance (219,093,086 samples, 0.06%)</title><rect x=3D"782.0" =
y=3D"1557" width=3D"0.7" height=3D"15.0" fill=3D"rgb(240,173,49)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"784.97" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>scheduler_tick (54,729,582 samples, 0.01%)</title><rect x=3D"704.5" y=
=3D"1557" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218,169,26)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"707.49" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__GI___ioctl (1,319,411,362 samples, 0.36%)</title><rect x=3D"49.8" y=3D=
"1717" width=3D"4.2" height=3D"15.0" fill=3D"rgb(245,55,32)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"52.75" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>kv=
m_arch_vcpu_load (402,390,541 samples, 0.11%)</title><rect x=3D"26.5" y=3D"=
85" width=3D"1.3" height=3D"15.0" fill=3D"rgb(212,22,7)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"29.49" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>__GI___i=
octl (1,616,765,146 samples, 0.44%)</title><rect x=3D"88.2" y=3D"1829" widt=
h=3D"5.1" height=3D"15.0" fill=3D"rgb(227,116,32)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"91.17" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_fo=
lio_gfp (573,879,416 samples, 0.15%)</title><rect x=3D"128.9" y=3D"1621" wi=
dth=3D"1.8" height=3D"15.0" fill=3D"rgb(244,15,19)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"131.89" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_=
folio_gfp (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"85" w=
idth=3D"3.5" height=3D"15.0" fill=3D"rgb(224,3,6)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"16.27" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interr=
upt (54,729,582 samples, 0.01%)</title><rect x=3D"704.5" y=3D"1637" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(217,7,35)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"707.49" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,0=
40,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1093" width=3D"19.2=
" height=3D"15.0" fill=3D"rgb(226,79,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"1103.5" ></text>=0A</g>=0A<g >=0A<title>try_to_wake_up (39,=
330,909 samples, 0.01%)</title><rect x=3D"143.6" y=3D"1573" width=3D"0.1" h=
eight=3D"15.0" fill=3D"rgb(241,160,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
146.59" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (1,60=
7,674,415 samples, 0.43%)</title><rect x=3D"184.8" y=3D"1829" width=3D"5.1"=
 height=3D"15.0" fill=3D"rgb(252,130,38)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"187.75" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>tlb_finish_mmu (32=
9,291,450 samples, 0.09%)</title><rect x=3D"1183.8" y=3D"1909" width=3D"1.1=
" height=3D"15.0" fill=3D"rgb(207,41,37)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1186.83" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_tim=
er_interrupt (199,463,518 samples, 0.05%)</title><rect x=3D"903.3" y=3D"190=
9" width=3D"0.7" height=3D"15.0" fill=3D"rgb(230,138,38)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"906.33" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>work=
ingset_activation (279,210,033 samples, 0.08%)</title><rect x=3D"127.1" y=
=3D"1717" width=3D"0.9" height=3D"15.0" fill=3D"rgb(214,107,48)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"130.08" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<tit=
le>do_fault (1,167,219,750 samples, 0.32%)</title><rect x=3D"55.1" y=3D"147=
7" width=3D"3.7" height=3D"15.0" fill=3D"rgb(249,22,0)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"58.10" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>[unknow=
n] (844,968,004 samples, 0.23%)</title><rect x=3D"10.0" y=3D"357" width=3D"=
2.7" height=3D"15.0" fill=3D"rgb(233,163,29)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"13.00" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (88,926=
,234,188 samples, 24.01%)</title><rect x=3D"500.1" y=3D"1781" width=3D"283.=
3" height=3D"15.0" fill=3D"rgb(206,33,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"503.06" y=3D"1791.5" >__do_fault</text>=0A</g>=0A<g >=0A<title>_raw_spi=
n_lock_irqsave (686,661,856 samples, 0.19%)</title><rect x=3D"81.2" y=3D"14=
45" width=3D"2.2" height=3D"15.0" fill=3D"rgb(209,72,31)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"84.24" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>kvm_t=
dp_mmu_zap_leafs (88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"=
1861" width=3D"0.3" height=3D"15.0" fill=3D"rgb(249,160,9)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"900.12" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>do=
_syscall_64 (1,655,662,953 samples, 0.45%)</title><rect x=3D"142.3" y=3D"19=
25" width=3D"5.2" height=3D"15.0" fill=3D"rgb(228,133,6)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"145.27" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>__up=
date_load_avg_se (354,960,434 samples, 0.10%)</title><rect x=3D"170.8" y=3D=
"1589" width=3D"1.1" height=3D"15.0" fill=3D"rgb(237,38,41)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"173.79" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>k=
vm_mmu_page_fault (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=
=3D"293" width=3D"8.0" height=3D"15.0" fill=3D"rgb(249,35,38)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"20.24" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>=
make_spte (55,266,319 samples, 0.01%)</title><rect x=3D"84.2" y=3D"1621" wi=
dth=3D"0.2" height=3D"15.0" fill=3D"rgb(229,5,25)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"87.24" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>timespec_ela=
psed (66,497,640 samples, 0.02%)</title><rect x=3D"440.0" y=3D"2037" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(254,147,38)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"443.05" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_=
lock (1,896,941,608 samples, 0.51%)</title><rect x=3D"113.3" y=3D"1525" wid=
th=3D"6.1" height=3D"15.0" fill=3D"rgb(237,127,48)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"116.35" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched=
_handle.isra.21 (177,285,076 samples, 0.05%)</title><rect x=3D"903.3" y=3D"=
1845" width=3D"0.6" height=3D"15.0" fill=3D"rgb(252,151,35)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"906.33" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>d=
o_syscall_64 (98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D"197" =
width=3D"0.3" height=3D"15.0" fill=3D"rgb(233,78,38)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"14.76" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>[unknown]=
 (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1525" width=3D=
"19.2" height=3D"15.0" fill=3D"rgb(226,32,21)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"13.00" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>psi_account_irqt=
ime (546,689,554 samples, 0.15%)</title><rect x=3D"779.1" y=3D"1669" width=
=3D"1.7" height=3D"15.0" fill=3D"rgb(228,22,47)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"782.10" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>finish_task_s=
witch (49,093,036 samples, 0.01%)</title><rect x=3D"26.3" y=3D"85" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(253,185,12)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"29.33" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault=
 (1,604,157,291 samples, 0.43%)</title><rect x=3D"93.4" y=3D"1701" width=3D=
"5.1" height=3D"15.0" fill=3D"rgb(205,53,34)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"96.39" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_faul=
t (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"261" width=3D=
"3.5" height=3D"15.0" fill=3D"rgb(235,190,1)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"16.27" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__x86_indirect_thu=
nk_array (313,390,568 samples, 0.08%)</title><rect x=3D"179.3" y=3D"2021" w=
idth=3D"0.9" height=3D"15.0" fill=3D"rgb(245,37,6)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"182.25" y=3D"2031.5" ></text>=0A</g>=0A<g >=0A<title>make_spte =
(813,751,460 samples, 0.22%)</title><rect x=3D"813.7" y=3D"1877" width=3D"2=
.6" height=3D"15.0" fill=3D"rgb(230,184,11)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"816.72" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault =
(995,097,640 samples, 0.27%)</title><rect x=3D"33.2" y=3D"1349" width=3D"3.=
2" height=3D"15.0" fill=3D"rgb(244,79,15)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"36.19" y=3D"1359.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,=
468,270,705 samples, 0.40%)</title><rect x=3D"37.7" y=3D"1573" width=3D"4.6=
" height=3D"15.0" fill=3D"rgb(221,69,18)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"40.67" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>copy_user_short_str=
ing (88,683,604 samples, 0.02%)</title><rect x=3D"272.9" y=3D"1925" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(254,229,37)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"275.85" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>down_read_ki=
llable (254,490,872 samples, 0.07%)</title><rect x=3D"155.5" y=3D"1765" wid=
th=3D"0.8" height=3D"15.0" fill=3D"rgb(230,91,1)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"158.48" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fa=
ult (2,423,604,255 samples, 0.65%)</title><rect x=3D"132.6" y=3D"1717" widt=
h=3D"7.7" height=3D"15.0" fill=3D"rgb(248,124,23)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"135.59" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>check_preem=
ption_disabled (289,507,050 samples, 0.08%)</title><rect x=3D"496.7" y=3D"1=
797" width=3D"0.9" height=3D"15.0" fill=3D"rgb(235,188,22)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"499.72" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>en=
try_SYSCALL_64 (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"45=
3" width=3D"2.5" height=3D"15.0" fill=3D"rgb(235,19,22)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"29.48" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>tick_sc=
hed_handle.isra.21 (49,270,795 samples, 0.01%)</title><rect x=3D"706.3" y=
=3D"1605" width=3D"0.1" height=3D"15.0" fill=3D"rgb(209,202,31)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"709.27" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__x64_sys_ioctl (1,616,765,146 samples, 0.44%)</title><rect x=3D"88.2" y=
=3D"1781" width=3D"5.1" height=3D"15.0" fill=3D"rgb(236,97,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"91.17" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title=
>kvm_faultin_pfn (1,410,897,962 samples, 0.38%)</title><rect x=3D"74.2" y=
=3D"1621" width=3D"4.5" height=3D"15.0" fill=3D"rgb(217,74,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"77.18" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title=
>shmem_fault (1,373,790,402 samples, 0.37%)</title><rect x=3D"74.3" y=3D"14=
93" width=3D"4.4" height=3D"15.0" fill=3D"rgb(215,58,25)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"77.30" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>kvm_v=
cpu_ioctl (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"325" =
width=3D"3.5" height=3D"15.0" fill=3D"rgb(213,61,20)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"16.27" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_sp=
in_lock (129,823,438 samples, 0.04%)</title><rect x=3D"52.6" y=3D"1381" wid=
th=3D"0.4" height=3D"15.0" fill=3D"rgb(242,175,38)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"55.62" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_=
exit (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=3D"309" width=
=3D"8.0" height=3D"15.0" fill=3D"rgb(242,134,47)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"20.24" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>update_sd_lb_s=
tats.constprop.137 (341,531,787 samples, 0.09%)</title><rect x=3D"769.2" y=
=3D"1621" width=3D"1.0" height=3D"15.0" fill=3D"rgb(217,179,33)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"772.16" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<tit=
le>shmem_fault (88,911,685,101 samples, 24.00%)</title><rect x=3D"500.1" y=
=3D"1765" width=3D"283.3" height=3D"15.0" fill=3D"rgb(209,93,23)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"503.11" y=3D"1775.5" >shmem_fault</text>=0A</g>=
=0A<g >=0A<title>internal_get_user_pages_fast (259,195,741 samples, 0.07%)<=
/title><rect x=3D"147.6" y=3D"1765" width=3D"0.9" height=3D"15.0" fill=3D"r=
gb(229,165,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.63" y=3D"1775.5" ></=
text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,488,009,723 samples, 0.40%)<=
/title><rect x=3D"37.7" y=3D"1621" width=3D"4.7" height=3D"15.0" fill=3D"rg=
b(240,33,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.67" y=3D"1631.5" ></text=
>=0A</g>=0A<g >=0A<title>__GI___ioctl (159,314,940 samples, 0.04%)</title><=
rect x=3D"10.8" y=3D"181" width=3D"0.5" height=3D"15.0" fill=3D"rgb(252,213=
,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"191.5" ></text>=0A</g>=
=0A<g >=0A<title>entry_SYSCALL_64 (1,833,266,047 samples, 0.49%)</title><re=
ct x=3D"68.2" y=3D"1749" width=3D"5.9" height=3D"15.0" fill=3D"rgb(235,66,5=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1759.5" ></text>=0A</g>=
=0A<g >=0A<title>tick_sched_handle.isra.21 (47,348,631 samples, 0.01%)</tit=
le><rect x=3D"706.7" y=3D"1621" width=3D"0.1" height=3D"15.0" fill=3D"rgb(2=
49,204,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.65" y=3D"1631.5" ></text>=
=0A</g>=0A<g >=0A<title>preempt_count_add (88,390,116 samples, 0.02%)</titl=
e><rect x=3D"1182.7" y=3D"1797" width=3D"0.3" height=3D"15.0" fill=3D"rgb(2=
54,167,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.70" y=3D"1807.5" ></tex=
t>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,468,270,705 samples, 0.40%)=
</title><rect x=3D"37.7" y=3D"1541" width=3D"4.6" height=3D"15.0" fill=3D"r=
gb(237,202,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.67" y=3D"1551.5" ></t=
ext>=0A</g>=0A<g >=0A<title>pollwake (312,099,913 samples, 0.08%)</title><r=
ect x=3D"109.2" y=3D"1509" width=3D"1.0" height=3D"15.0" fill=3D"rgb(215,24=
,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.19" y=3D"1519.5" ></text>=0A</=
g>=0A<g >=0A<title>do_raw_spin_lock (705,038,517 samples, 0.19%)</title><re=
ct x=3D"33.4" y=3D"1301" width=3D"2.2" height=3D"15.0" fill=3D"rgb(225,9,39=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"36.38" y=3D"1311.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_vcpu_ioctl (133,604,879,493 samples, 36.07%)</title><r=
ect x=3D"449.9" y=3D"1989" width=3D"425.6" height=3D"15.0" fill=3D"rgb(218,=
55,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"452.89" y=3D"1999.5" >kvm_vcpu_io=
ctl</text>=0A</g>=0A<g >=0A<title>handle_userfault (1,473,606,899 samples, =
0.40%)</title><rect x=3D"61.8" y=3D"1429" width=3D"4.6" height=3D"15.0" fil=
l=3D"rgb(234,136,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"64.75" y=3D"1439.5"=
 ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (123,122,609 samples, 0=
.03%)</title><rect x=3D"11.4" y=3D"69" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(223,62,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"79.5" ></=
text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (194,284,188 samples, 0.0=
5%)</title><rect x=3D"111.3" y=3D"1461" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(235,202,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.26" y=3D"1471.5=
" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (48,893,=
339 samples, 0.01%)</title><rect x=3D"492.6" y=3D"1797" width=3D"0.2" heigh=
t=3D"15.0" fill=3D"rgb(239,49,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"495.61=
" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (8=
8,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"2005" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(216,202,13)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"900.12" y=3D"2015.5" ></text>=0A</g>=0A<g >=0A<title>free_unref_page_pr=
epare.part.82 (44,049,896 samples, 0.01%)</title><rect x=3D"1177.2" y=3D"17=
97" width=3D"0.2" height=3D"15.0" fill=3D"rgb(215,150,22)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1180.24" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>kv=
m_tdp_page_fault (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"=
293" width=3D"0.4" height=3D"15.0" fill=3D"rgb(235,44,1)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"28.18" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>handle=
_userfault (182,037,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"37" wi=
dth=3D"0.6" height=3D"15.0" fill=3D"rgb(207,176,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"15.69" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>mtree_load=
 (307,859,616 samples, 0.08%)</title><rect x=3D"790.5" y=3D"1861" width=3D"=
0.9" height=3D"15.0" fill=3D"rgb(251,166,6)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"793.45" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_stat=
e (110,344,718 samples, 0.03%)</title><rect x=3D"1175.1" y=3D"1813" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(235,135,33)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1178.06" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>__perf_even=
t_task_sched_out (60,119,269 samples, 0.02%)</title><rect x=3D"17.0" y=3D"3=
7" width=3D"0.2" height=3D"15.0" fill=3D"rgb(238,146,22)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"20.02" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>__handl=
e_mm_fault (1,075,357,417 samples, 0.29%)</title><rect x=3D"68.8" y=3D"1525=
" width=3D"3.5" height=3D"15.0" fill=3D"rgb(239,188,34)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"71.83" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>__hrti=
mer_run_queues (54,729,582 samples, 0.01%)</title><rect x=3D"704.5" y=3D"16=
21" width=3D"0.2" height=3D"15.0" fill=3D"rgb(237,92,41)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"707.49" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>[unk=
nown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"869" widt=
h=3D"19.2" height=3D"15.0" fill=3D"rgb(211,207,34)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"13.00" y=3D"879.5" ></text>=0A</g>=0A<g >=0A<title>mm_alloc_pmd=
 (138,692,126 samples, 0.04%)</title><rect x=3D"890.2" y=3D"1957" width=3D"=
0.4" height=3D"15.0" fill=3D"rgb(236,221,50)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"893.16" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>folio_activate (=
1,533,555,501 samples, 0.41%)</title><rect x=3D"798.7" y=3D"1861" width=3D"=
4.9" height=3D"15.0" fill=3D"rgb(237,47,39)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"801.67" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (30,935=
,891,570 samples, 8.35%)</title><rect x=3D"10.0" y=3D"1877" width=3D"98.6" =
height=3D"15.0" fill=3D"rgb(221,15,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
13.00" y=3D"1887.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>_raw_spin_lock=
_irqsave (1,423,413,484 samples, 0.38%)</title><rect x=3D"160.3" y=3D"1637"=
 width=3D"4.5" height=3D"15.0" fill=3D"rgb(205,103,16)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"163.26" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>__x64_=
sys_ioctl (140,678,447,484 samples, 37.98%)</title><rect x=3D"447.6" y=3D"2=
005" width=3D"448.2" height=3D"15.0" fill=3D"rgb(232,47,35)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"450.60" y=3D"2015.5" >__x64_sys_ioctl</text>=0A</g>=0A=
<g >=0A<title>__mod_node_page_state (66,082,214 samples, 0.02%)</title><rec=
t x=3D"1179.6" y=3D"1749" width=3D"0.2" height=3D"15.0" fill=3D"rgb(230,137=
,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.56" y=3D"1759.5" ></text>=0A<=
/g>=0A<g >=0A<title>get_user_pages_unlocked (1,821,514,697 samples, 0.49%)<=
/title><rect x=3D"42.4" y=3D"1509" width=3D"5.8" height=3D"15.0" fill=3D"rg=
b(254,167,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.42" y=3D"1519.5" ></te=
xt>=0A</g>=0A<g >=0A<title>syscall_enter_from_user_mode (66,481,119 samples=
, 0.02%)</title><rect x=3D"895.8" y=3D"2005" width=3D"0.2" height=3D"15.0" =
fill=3D"rgb(233,169,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"898.78" y=3D"201=
5.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (2,491,551,090 samples=
, 0.67%)</title><rect x=3D"17.2" y=3D"373" width=3D"8.0" height=3D"15.0" fi=
ll=3D"rgb(232,13,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"383.5"=
 ></text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid (664,940,099 sample=
s, 0.18%)</title><rect x=3D"906.1" y=3D"1941" width=3D"2.1" height=3D"15.0"=
 fill=3D"rgb(213,185,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"909.09" y=3D"1=
951.5" ></text>=0A</g>=0A<g >=0A<title>__mmu_notifier_invalidate_range_star=
t (88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"1909" width=3D"=
0.3" height=3D"15.0" fill=3D"rgb(238,134,8)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"900.12" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (=
1,211,902,461 samples, 0.33%)</title><rect x=3D"55.0" y=3D"1573" width=3D"3=
.8" height=3D"15.0" fill=3D"rgb(212,114,26)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"57.96" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release_page_c=
lean (234,113,139 samples, 0.06%)</title><rect x=3D"48.2" y=3D"1541" width=
=3D"0.8" height=3D"15.0" fill=3D"rgb(205,229,37)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"51.22" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count=
_sub (327,778,017 samples, 0.09%)</title><rect x=3D"536.2" y=3D"1653" width=
=3D"1.1" height=3D"15.0" fill=3D"rgb(240,159,10)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"539.22" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_=
fault (89,781,353,740 samples, 24.24%)</title><rect x=3D"498.1" y=3D"1813" =
width=3D"286.0" height=3D"15.0" fill=3D"rgb(252,218,1)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"501.07" y=3D"1823.5" >__handle_mm_fault</text>=0A</g>=0A<g =
>=0A<title>hva_to_pfn (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" =
y=3D"261" width=3D"0.4" height=3D"15.0" fill=3D"rgb(210,59,12)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"28.18" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>=
syscall_return_via_sysret (310,279,964 samples, 0.08%)</title><rect x=3D"43=
8.9" y=3D"2021" width=3D"1.0" height=3D"15.0" fill=3D"rgb(229,131,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"441.92" y=3D"2031.5" ></text>=0A</g>=0A<g =
>=0A<title>__x64_sys_ioctl (59,449,801 samples, 0.02%)</title><rect x=3D"12=
.5" y=3D"245" width=3D"0.2" height=3D"15.0" fill=3D"rgb(246,191,34)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<t=
itle>shmem_get_folio_gfp (182,037,942 samples, 0.05%)</title><rect x=3D"12.=
7" y=3D"53" width=3D"0.6" height=3D"15.0" fill=3D"rgb(211,5,52)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"15.69" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>=
handle_mm_fault (91,476,411,291 samples, 24.70%)</title><rect x=3D"494.5" y=
=3D"1829" width=3D"291.4" height=3D"15.0" fill=3D"rgb(230,65,10)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"497.46" y=3D"1839.5" >handle_mm_fault</text>=0A</=
g>=0A<g >=0A<title>vmx_vcpu_run (50,953,513 samples, 0.01%)</title><rect x=
=3D"178.9" y=3D"1909" width=3D"0.1" height=3D"15.0" fill=3D"rgb(207,112,46)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"181.88" y=3D"1919.5" ></text>=0A</g>=
=0A<g >=0A<title>ktime_get_update_offsets_now (394,065,614 samples, 0.11%)<=
/title><rect x=3D"1033.0" y=3D"1877" width=3D"1.2" height=3D"15.0" fill=3D"=
rgb(236,211,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.99" y=3D"1887.5" >=
</text>=0A</g>=0A<g >=0A<title>schedule (404,205,470 samples, 0.11%)</title=
><rect x=3D"77.4" y=3D"1445" width=3D"1.3" height=3D"15.0" fill=3D"rgb(223,=
134,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80.39" y=3D"1455.5" ></text>=0A=
</g>=0A<g >=0A<title>schedule (50,279,799 samples, 0.01%)</title><rect x=3D=
"154.1" y=3D"1637" width=3D"0.2" height=3D"15.0" fill=3D"rgb(216,19,46)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"157.14" y=3D"1647.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_arch_vcpu_ioctl_run (1,590,623,571 samples, 0.43%)</title><r=
ect x=3D"54.0" y=3D"1653" width=3D"5.1" height=3D"15.0" fill=3D"rgb(212,119=
,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>entry_SYSCALL_64 (3,348,716,533 samples, 0.90%)</title><re=
ct x=3D"147.5" y=3D"1957" width=3D"10.7" height=3D"15.0" fill=3D"rgb(210,15=
1,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.55" y=3D"1967.5" ></text>=0A<=
/g>=0A<g >=0A<title>syscall_return_via_sysret (553,865,735 samples, 0.15%)<=
/title><rect x=3D"1172.4" y=3D"2037" width=3D"1.7" height=3D"15.0" fill=3D"=
rgb(238,17,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1175.36" y=3D"2047.5" ><=
/text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (104,991,582 samples, 0.03%)</=
title><rect x=3D"147.2" y=3D"1829" width=3D"0.3" height=3D"15.0" fill=3D"rg=
b(215,209,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.21" y=3D"1839.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__get_user_pages (1,026,979,445 samples, 0.28%)=
</title><rect x=3D"84.6" y=3D"1605" width=3D"3.3" height=3D"15.0" fill=3D"r=
gb(241,171,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1615.5" ></t=
ext>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (2,079,126,509 samples, 0.5=
6%)</title><rect x=3D"100.0" y=3D"1557" width=3D"6.6" height=3D"15.0" fill=
=3D"rgb(235,79,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.98" y=3D"1567.5"=
 ></text>=0A</g>=0A<g >=0A<title>trigger_load_balance (269,433,971 samples,=
 0.07%)</title><rect x=3D"262.3" y=3D"1829" width=3D"0.9" height=3D"15.0" f=
ill=3D"rgb(207,5,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31" y=3D"1839.=
5" ></text>=0A</g>=0A<g >=0A<title>pollwake (66,326,347 samples, 0.02%)</ti=
tle><rect x=3D"16.8" y=3D"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb(244=
,112,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"47.5" ></text>=0A</=
g>=0A<g >=0A<title>__GI___ioctl (2,305,287,529 samples, 0.62%)</title><rect=
 x=3D"42.4" y=3D"1701" width=3D"7.4" height=3D"15.0" fill=3D"rgb(240,106,33=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1711.5" ></text>=0A</g>=
=0A<g >=0A<title>handle_userfault (61,757,117 samples, 0.02%)</title><rect =
x=3D"29.0" y=3D"165" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,112,40)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"175.5" ></text>=0A</g>=0A<g=
 >=0A<title>find_busiest_group (54,093,156 samples, 0.01%)</title><rect x=
=3D"29.0" y=3D"69" width=3D"0.2" height=3D"15.0" fill=3D"rgb(240,44,48)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"32.02" y=3D"79.5" ></text>=0A</g>=0A<g >=
=0A<title>__GI___ioctl (1,506,756,619 samples, 0.41%)</title><rect x=3D"37.=
6" y=3D"1685" width=3D"4.8" height=3D"15.0" fill=3D"rgb(217,73,37)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"40.61" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__get_user_pages (95,063,113,898 samples, 25.67%)</title><rect x=3D"48=
3.0" y=3D"1845" width=3D"302.9" height=3D"15.0" fill=3D"rgb(231,222,6)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"486.03" y=3D"1855.5" >__get_user_pages</te=
xt>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,821,514,697 samples, 0.49%)</title=
><rect x=3D"42.4" y=3D"1525" width=3D"5.8" height=3D"15.0" fill=3D"rgb(214,=
61,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.42" y=3D"1535.5" ></text>=0A</=
g>=0A<g >=0A<title>__schedule (223,371,606 samples, 0.06%)</title><rect x=
=3D"146.3" y=3D"1605" width=3D"0.7" height=3D"15.0" fill=3D"rgb(207,65,29)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"149.28" y=3D"1615.5" ></text>=0A</g>=0A=
<g >=0A<title>__hrtimer_run_queues (219,093,086 samples, 0.06%)</title><rec=
t x=3D"782.0" y=3D"1621" width=3D"0.7" height=3D"15.0" fill=3D"rgb(250,148,=
23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=3D"1631.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (3,348,716,533 samples, 0.90%)</t=
itle><rect x=3D"147.5" y=3D"1893" width=3D"10.7" height=3D"15.0" fill=3D"rg=
b(212,85,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.55" y=3D"1903.5" ></te=
xt>=0A</g>=0A<g >=0A<title>tlb_flush_mmu (329,291,450 samples, 0.09%)</titl=
e><rect x=3D"1183.8" y=3D"1893" width=3D"1.1" height=3D"15.0" fill=3D"rgb(2=
33,83,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.83" y=3D"1903.5" ></text=
>=0A</g>=0A<g >=0A<title>vmx_interrupt_allowed (299,240,479 samples, 0.08%)=
</title><rect x=3D"793.6" y=3D"1861" width=3D"0.9" height=3D"15.0" fill=3D"=
rgb(243,179,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"796.58" y=3D"1871.5" ><=
/text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (59,449,801 samples, 0.02%)</t=
itle><rect x=3D"12.5" y=3D"229" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
51,15,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"239.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (123,122,609 samples, 0.03%)</ti=
tle><rect x=3D"11.4" y=3D"85" width=3D"0.4" height=3D"15.0" fill=3D"rgb(249=
,110,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"95.5" ></text>=0A<=
/g>=0A<g >=0A<title>__x64_sys_ioctl (1,539,194,524 samples, 0.42%)</title><=
rect x=3D"167.5" y=3D"1957" width=3D"4.9" height=3D"15.0" fill=3D"rgb(219,1=
59,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.50" y=3D"1967.5" ></text>=0A=
</g>=0A<g >=0A<title>hva_to_pfn (2,240,137,502 samples, 0.60%)</title><rect=
 x=3D"99.5" y=3D"1685" width=3D"7.1" height=3D"15.0" fill=3D"rgb(243,155,0)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.47" y=3D"1695.5" ></text>=0A</g>=
=0A<g >=0A<title>__filemap_get_folio (109,624,453 samples, 0.03%)</title><r=
ect x=3D"88.4" y=3D"1509" width=3D"0.3" height=3D"15.0" fill=3D"rgb(227,137=
,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36" y=3D"1519.5" ></text>=0A</g=
>=0A<g >=0A<title>_raw_spin_lock_irqsave (663,211,659 samples, 0.18%)</titl=
e><rect x=3D"69.0" y=3D"1413" width=3D"2.1" height=3D"15.0" fill=3D"rgb(219=
,110,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.99" y=3D"1423.5" ></text>=
=0A</g>=0A<g >=0A<title>shmem_fault (2,165,906,632 samples, 0.58%)</title><=
rect x=3D"148.6" y=3D"1685" width=3D"6.9" height=3D"15.0" fill=3D"rgb(230,1=
87,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"151.58" y=3D"1695.5" ></text>=0A=
</g>=0A<g >=0A<title>shmem_fault (1,381,981,405 samples, 0.37%)</title><rec=
t x=3D"93.9" y=3D"1557" width=3D"4.4" height=3D"15.0" fill=3D"rgb(252,47,40=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.91" y=3D"1567.5" ></text>=0A</g>=
=0A<g >=0A<title>perf_adjust_freq_unthr_context (66,501,182 samples, 0.02%)=
</title><rect x=3D"274.1" y=3D"1765" width=3D"0.2" height=3D"15.0" fill=3D"=
rgb(210,205,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.06" y=3D"1775.5" ><=
/text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,523,136,454 samples, 0.4=
1%)</title><rect x=3D"122.2" y=3D"1669" width=3D"4.9" height=3D"15.0" fill=
=3D"rgb(236,77,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"125.22" y=3D"1679.5"=
 ></text>=0A</g>=0A<g >=0A<title>shmem_fault (145,741,482 samples, 0.04%)</=
title><rect x=3D"25.2" y=3D"149" width=3D"0.4" height=3D"15.0" fill=3D"rgb(=
235,126,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"159.5" ></text>=
=0A</g>=0A<g >=0A<title>memcg_stats_lock (132,955,272 samples, 0.04%)</titl=
e><rect x=3D"497.6" y=3D"1797" width=3D"0.5" height=3D"15.0" fill=3D"rgb(24=
2,219,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"500.64" y=3D"1807.5" ></text>=
=0A</g>=0A<g >=0A<title>make_spte (54,392,863 samples, 0.01%)</title><rect =
x=3D"130.8" y=3D"1749" width=3D"0.1" height=3D"15.0" fill=3D"rgb(249,145,10=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.78" y=3D"1759.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_vcpu_load (44,966,406 samples, 0.01%)</title><rect x=
=3D"171.9" y=3D"1605" width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,94,18)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"174.93" y=3D"1615.5" ></text>=0A</g>=0A=
<g >=0A<title>psi_task_switch (357,623,460 samples, 0.10%)</title><rect x=
=3D"139.2" y=3D"1573" width=3D"1.1" height=3D"15.0" fill=3D"rgb(219,85,25)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"142.17" y=3D"1583.5" ></text>=0A</g>=0A=
<g >=0A<title>change_prot_numa (132,959,376 samples, 0.04%)</title><rect x=
=3D"1170.9" y=3D"1941" width=3D"0.4" height=3D"15.0" fill=3D"rgb(230,100,44=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1951.5" ></text>=0A</g>=
=0A<g >=0A<title>ktime_get_coarse_real_ts64 (44,299,942 samples, 0.01%)</ti=
tle><rect x=3D"438.7" y=3D"1973" width=3D"0.1" height=3D"15.0" fill=3D"rgb(=
206,48,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.71" y=3D"1983.5" ></text=
>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (686,661,856 samples, 0.19%)</tit=
le><rect x=3D"81.2" y=3D"1429" width=3D"2.2" height=3D"15.0" fill=3D"rgb(23=
0,93,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.24" y=3D"1439.5" ></text>=
=0A</g>=0A<g >=0A<title>update_process_times (54,729,582 samples, 0.01%)</t=
itle><rect x=3D"704.5" y=3D"1573" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(242,89,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.49" y=3D"1583.5" ></tex=
t>=0A</g>=0A<g >=0A<title>check_preemption_disabled (208,886,389 samples, 0=
.06%)</title><rect x=3D"745.0" y=3D"1653" width=3D"0.7" height=3D"15.0" fil=
l=3D"rgb(252,39,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"748.03" y=3D"1663.5"=
 ></text>=0A</g>=0A<g >=0A<title>handle_uffd_page_request (88,665,678 sampl=
es, 0.02%)</title><rect x=3D"1189.3" y=3D"2053" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(208,94,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1192.25" y=3D"=
2063.5" ></text>=0A</g>=0A<g >=0A<title>kvm_pfn_to_refcounted_page (75,413,=
338 samples, 0.02%)</title><rect x=3D"11.4" y=3D"37" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(211,76,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37"=
 y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (10,172,750,598 sampl=
es, 2.75%)</title><rect x=3D"10.0" y=3D"1701" width=3D"32.4" height=3D"15.0=
" fill=3D"rgb(224,166,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1=
711.5" >[u..</text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (99,714,073 sampl=
es, 0.03%)</title><rect x=3D"12.1" y=3D"181" width=3D"0.3" height=3D"15.0" =
fill=3D"rgb(237,126,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.08" y=3D"191=
.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (123,122,609 samples, 0.0=
3%)</title><rect x=3D"11.4" y=3D"181" width=3D"0.4" height=3D"15.0" fill=3D=
"rgb(205,149,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"191.5" ></=
text>=0A</g>=0A<g >=0A<title>up_read (121,540,832 samples, 0.03%)</title><r=
ect x=3D"58.4" y=3D"1397" width=3D"0.4" height=3D"15.0" fill=3D"rgb(213,144=
,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.43" y=3D"1407.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_tdp_page_fault (1,713,931,057 samples, 0.46%)</title>=
<rect x=3D"74.2" y=3D"1637" width=3D"5.4" height=3D"15.0" fill=3D"rgb(222,1=
32,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.18" y=3D"1647.5" ></text>=0A<=
/g>=0A<g >=0A<title>do_syscall_64 (159,314,940 samples, 0.04%)</title><rect=
 x=3D"10.8" y=3D"149" width=3D"0.5" height=3D"15.0" fill=3D"rgb(229,54,5)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"159.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_is_mmio_pfn (123,852,408 samples, 0.03%)</title><rect x=3D"9=
2.4" y=3D"1637" width=3D"0.4" height=3D"15.0" fill=3D"rgb(227,172,18)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"95.36" y=3D"1647.5" ></text>=0A</g>=0A<g >=
=0A<title>__do_fault (1,026,979,445 samples, 0.28%)</title><rect x=3D"84.6"=
 y=3D"1541" width=3D"3.3" height=3D"15.0" fill=3D"rgb(217,207,3)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<tit=
le>vmx_handle_exit (98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D=
"117" width=3D"0.3" height=3D"15.0" fill=3D"rgb(237,41,37)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"14.76" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>__do=
_fault (1,024,160,904 samples, 0.28%)</title><rect x=3D"33.1" y=3D"1397" wi=
dth=3D"3.3" height=3D"15.0" fill=3D"rgb(240,98,14)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"36.10" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>folio_batch=
_move_lru (230,736,897 samples, 0.06%)</title><rect x=3D"48.2" y=3D"1493" w=
idth=3D"0.8" height=3D"15.0" fill=3D"rgb(224,226,40)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"51.22" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>folio_ma=
rk_accessed (196,324,174 samples, 0.05%)</title><rect x=3D"73.1" y=3D"1589"=
 width=3D"0.6" height=3D"15.0" fill=3D"rgb(231,211,13)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"76.06" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>up_read=
 (199,462,540 samples, 0.05%)</title><rect x=3D"250.6" y=3D"1941" width=3D"=
0.7" height=3D"15.0" fill=3D"rgb(249,77,24)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"253.64" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_tim=
er_interrupt (155,138,716 samples, 0.04%)</title><rect x=3D"274.0" y=3D"189=
3" width=3D"0.5" height=3D"15.0" fill=3D"rgb(244,101,41)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"276.99" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>__ta=
sk_pid_nr_ns (88,657,886 samples, 0.02%)</title><rect x=3D"438.2" y=3D"1973=
" width=3D"0.3" height=3D"15.0" fill=3D"rgb(219,37,32)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"441.21" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>mem_cg=
roup_from_task (264,864,780 samples, 0.07%)</title><rect x=3D"47.4" y=3D"14=
61" width=3D"0.8" height=3D"15.0" fill=3D"rgb(252,62,49)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"50.38" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>vmx_v=
cpu_load (1,640,029,704 samples, 0.44%)</title><rect x=3D"760.9" y=3D"1653"=
 width=3D"5.2" height=3D"15.0" fill=3D"rgb(216,123,6)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"763.89" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__hrtim=
er_run_queues (177,285,076 samples, 0.05%)</title><rect x=3D"903.3" y=3D"18=
77" width=3D"0.6" height=3D"15.0" fill=3D"rgb(254,219,31)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"906.33" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>_ra=
w_spin_lock_irqsave (39,330,909 samples, 0.01%)</title><rect x=3D"143.6" y=
=3D"1557" width=3D"0.1" height=3D"15.0" fill=3D"rgb(251,29,15)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"146.59" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<titl=
e>shmem_fault (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"1=
01" width=3D"3.5" height=3D"15.0" fill=3D"rgb(233,97,14)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"16.27" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>kvm_ar=
ch_vcpu_ioctl_run (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=
=3D"341" width=3D"8.0" height=3D"15.0" fill=3D"rgb(221,34,41)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"20.24" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>=
raw_spin_rq_lock_nested.constprop.116 (110,459,535 samples, 0.03%)</title><=
rect x=3D"776.3" y=3D"1685" width=3D"0.4" height=3D"15.0" fill=3D"rgb(220,1=
56,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"779.34" y=3D"1695.5" ></text>=0A=
</g>=0A<g >=0A<title>__do_fault (2,423,604,255 samples, 0.65%)</title><rect=
 x=3D"132.6" y=3D"1669" width=3D"7.7" height=3D"15.0" fill=3D"rgb(221,17,10=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"1679.5" ></text>=0A</g>=
=0A<g >=0A<title>dequeue_task_fair (384,772,501 samples, 0.10%)</title><rec=
t x=3D"164.9" y=3D"1621" width=3D"1.3" height=3D"15.0" fill=3D"rgb(208,138,=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.93" y=3D"1631.5" ></text>=0A</g>=
=0A<g >=0A<title>perf_event_task_tick (160,833,494 samples, 0.04%)</title><=
rect x=3D"834.2" y=3D"1765" width=3D"0.5" height=3D"15.0" fill=3D"rgb(207,5=
2,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1775.5" ></text>=0A<=
/g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,356,735,820 samples, 0.37%)</title><r=
ect x=3D"128.2" y=3D"1861" width=3D"4.3" height=3D"15.0" fill=3D"rgb(212,21=
2,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1871.5" ></text>=0A<=
/g>=0A<g >=0A<title>vmx_handle_exit (1,838,413,419 samples, 0.50%)</title><=
rect x=3D"184.2" y=3D"1925" width=3D"5.8" height=3D"15.0" fill=3D"rgb(218,1=
58,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"187.15" y=3D"1935.5" ></text>=0A=
</g>=0A<g >=0A<title>kvm_mmu_page_fault (2,433,229,386 samples, 0.66%)</tit=
le><rect x=3D"132.6" y=3D"1813" width=3D"7.7" height=3D"15.0" fill=3D"rgb(2=
12,141,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.58" y=3D"1823.5" ></text=
>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (340,536,211 samples, 0.09%=
)</title><rect x=3D"110.2" y=3D"1525" width=3D"1.1" height=3D"15.0" fill=3D=
"rgb(234,103,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"113.18" y=3D"1535.5" ><=
/text>=0A</g>=0A<g >=0A<title>__get_current_cr3_fast (434,719,119 samples, =
0.12%)</title><rect x=3D"869.3" y=3D"1925" width=3D"1.4" height=3D"15.0" fi=
ll=3D"rgb(216,27,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"872.32" y=3D"1935.=
5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,678,566,158 samples, 0.45%=
)</title><rect x=3D"173.4" y=3D"1749" width=3D"5.4" height=3D"15.0" fill=3D=
"rgb(222,85,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.45" y=3D"1759.5" ><=
/text>=0A</g>=0A<g >=0A<title>in_lock_functions (347,247,969 samples, 0.09%=
)</title><rect x=3D"885.6" y=3D"1909" width=3D"1.1" height=3D"15.0" fill=3D=
"rgb(212,95,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"888.64" y=3D"1919.5" ><=
/text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (2,196,033,458 samples, 0.5=
9%)</title><rect x=3D"99.6" y=3D"1621" width=3D"7.0" height=3D"15.0" fill=
=3D"rgb(231,46,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.61" y=3D"1631.5"=
 ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (72,651,74=
4 samples, 0.02%)</title><rect x=3D"704.4" y=3D"1685" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(211,130,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.4=
3" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,322,=
294,841 samples, 0.36%)</title><rect x=3D"890.6" y=3D"1941" width=3D"4.2" h=
eight=3D"15.0" fill=3D"rgb(224,53,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"8=
93.60" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__free_one_page (176,58=
4,055 samples, 0.05%)</title><rect x=3D"1176.5" y=3D"1781" width=3D"0.6" he=
ight=3D"15.0" fill=3D"rgb(253,38,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
79.54" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (8,665,993,97=
9 samples, 2.34%)</title><rect x=3D"10.0" y=3D"1685" width=3D"27.6" height=
=3D"15.0" fill=3D"rgb(228,105,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00"=
 y=3D"1695.5" >[..</text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 s=
amples, 1.63%)</title><rect x=3D"10.0" y=3D"1509" width=3D"19.2" height=3D"=
15.0" fill=3D"rgb(248,30,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D=
"1519.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_notifier_invalidate_range_=
start (88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"1893" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(225,49,1)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"900.12" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pf=
n (1,724,589,751 samples, 0.47%)</title><rect x=3D"173.3" y=3D"1861" width=
=3D"5.5" height=3D"15.0" fill=3D"rgb(241,35,19)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"176.30" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>kthread_is_pe=
r_cpu (114,371,254 samples, 0.03%)</title><rect x=3D"27.8" y=3D"37" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(206,98,52)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"30.77" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock=
 (52,384,258,462 samples, 14.14%)</title><rect x=3D"537.4" y=3D"1685" width=
=3D"166.9" height=3D"15.0" fill=3D"rgb(248,3,43)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"540.40" y=3D"1695.5" >do_raw_spin_lock</text>=0A</g>=0A<g >=0A<ti=
tle>_raw_spin_lock (62,840,882 samples, 0.02%)</title><rect x=3D"24.7" y=3D=
"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb(220,158,10)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"27.71" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>entry=
_SYSCALL_64 (56,164,306,477 samples, 15.16%)</title><rect x=3D"253.6" y=3D"=
2021" width=3D"178.9" height=3D"15.0" fill=3D"rgb(244,147,10)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"256.60" y=3D"2031.5" >entry_SYSCALL_64</text>=0A</g=
>=0A<g >=0A<title>get_user_pages_unlocked (790,301,371 samples, 0.21%)</tit=
le><rect x=3D"26.5" y=3D"277" width=3D"2.5" height=3D"15.0" fill=3D"rgb(207=
,122,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"287.5" ></text>=0A=
</g>=0A<g >=0A<title>__update_load_avg_se (384,772,501 samples, 0.10%)</tit=
le><rect x=3D"164.9" y=3D"1573" width=3D"1.3" height=3D"15.0" fill=3D"rgb(2=
33,24,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.93" y=3D"1583.5" ></text>=
=0A</g>=0A<g >=0A<title>__mod_memcg_lruvec_state (53,232,225 samples, 0.01%=
)</title><rect x=3D"802.4" y=3D"1813" width=3D"0.2" height=3D"15.0" fill=3D=
"rgb(224,33,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"805.40" y=3D"1823.5" ><=
/text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</tit=
le><rect x=3D"10.0" y=3D"917" width=3D"19.2" height=3D"15.0" fill=3D"rgb(21=
9,168,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"927.5" ></text>=
=0A</g>=0A<g >=0A<title>scheduler_tick (47,348,631 samples, 0.01%)</title><=
rect x=3D"706.7" y=3D"1589" width=3D"0.1" height=3D"15.0" fill=3D"rgb(220,1=
47,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"709.65" y=3D"1599.5" ></text>=0A=
</g>=0A<g >=0A<title>__GI___ioctl (3,104,413,288 samples, 0.84%)</title><re=
ct x=3D"98.7" y=3D"1861" width=3D"9.9" height=3D"15.0" fill=3D"rgb(209,127,=
48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.67" y=3D"1871.5" ></text>=0A</g=
>=0A<g >=0A<title>__x64_sys_ioctl (790,301,371 samples, 0.21%)</title><rect=
 x=3D"26.5" y=3D"421" width=3D"2.5" height=3D"15.0" fill=3D"rgb(253,107,10)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"431.5" ></text>=0A</g>=0A<=
g >=0A<title>record_times (122,017,331 samples, 0.03%)</title><rect x=3D"77=
5.4" y=3D"1653" width=3D"0.4" height=3D"15.0" fill=3D"rgb(236,117,20)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"778.42" y=3D"1663.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_arch_vcpu_ioctl_run (1,657,361,967 samples, 0.45%)</title><r=
ect x=3D"93.4" y=3D"1765" width=3D"5.3" height=3D"15.0" fill=3D"rgb(209,42,=
42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.39" y=3D"1775.5" ></text>=0A</g>=
=0A<g >=0A<title>sysvec_apic_timer_interrupt (571,370,498 samples, 0.15%)</=
title><rect x=3D"1032.4" y=3D"1925" width=3D"1.8" height=3D"15.0" fill=3D"r=
gb(205,80,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.43" y=3D"1935.5" ></=
text>=0A</g>=0A<g >=0A<title>xas_descend (686,865,897 samples, 0.19%)</titl=
e><rect x=3D"507.2" y=3D"1701" width=3D"2.1" height=3D"15.0" fill=3D"rgb(20=
5,78,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"510.15" y=3D"1711.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (2,179,708,244 samples, 0.59%)</title=
><rect x=3D"121.2" y=3D"1877" width=3D"7.0" height=3D"15.0" fill=3D"rgb(252=
,204,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.25" y=3D"1887.5" ></text>=
=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (320,178,889 samples, 0.09%)</title>=
<rect x=3D"120.2" y=3D"1765" width=3D"1.0" height=3D"15.0" fill=3D"rgb(220,=
50,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"123.23" y=3D"1775.5" ></text>=0A=
</g>=0A<g >=0A<title>down_read_killable (98,102,681 samples, 0.03%)</title>=
<rect x=3D"12.1" y=3D"37" width=3D"0.3" height=3D"15.0" fill=3D"rgb(210,148=
,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.08" y=3D"47.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (993,176,439 samples, 0.27%)</title><rect=
 x=3D"13.6" y=3D"53" width=3D"3.2" height=3D"15.0" fill=3D"rgb(213,117,47)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.65" y=3D"63.5" ></text>=0A</g>=0A<g =
>=0A<title>get_user_pages_unlocked (1,001,481,897 samples, 0.27%)</title><r=
ect x=3D"81.0" y=3D"1605" width=3D"3.2" height=3D"15.0" fill=3D"rgb(222,88,=
45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.96" y=3D"1615.5" ></text>=0A</g>=
=0A<g >=0A<title>schedule (790,301,371 samples, 0.21%)</title><rect x=3D"26=
.5" y=3D"133" width=3D"2.5" height=3D"15.0" fill=3D"rgb(214,74,16)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>finish_task_switch (50,048,692 samples, 0.01%)</title><rect x=3D"171.9"=
 y=3D"1637" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,5,42)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"174.92" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__filemap_get_folio (49,434,611 samples, 0.01%)</title><rect x=3D"13.3" =
y=3D"69" width=3D"0.1" height=3D"15.0" fill=3D"rgb(226,56,53)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"16.27" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>n=
ative_queued_spin_lock_slowpath (274,094,152 samples, 0.07%)</title><rect x=
=3D"84.7" y=3D"1429" width=3D"0.9" height=3D"15.0" fill=3D"rgb(245,172,50)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.70" y=3D"1439.5" ></text>=0A</g>=0A<=
g >=0A<title>entry_SYSCALL_64 (140,900,049,549 samples, 38.04%)</title><rec=
t x=3D"447.4" y=3D"2037" width=3D"448.9" height=3D"15.0" fill=3D"rgb(208,17=
3,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"450.39" y=3D"2047.5" >entry_SYSCA=
LL_64</text>=0A</g>=0A<g >=0A<title>_nl_C_LC_CTYPE_tolower (4,643,693,233 s=
amples, 1.25%)</title><rect x=3D"1174.1" y=3D"2053" width=3D"14.8" height=
=3D"15.0" fill=3D"rgb(231,184,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.=
12" y=3D"2063.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (557,657,=
094 samples, 0.15%)</title><rect x=3D"44.2" y=3D"1333" width=3D"1.8" height=
=3D"15.0" fill=3D"rgb(237,26,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"47.23"=
 y=3D"1343.5" ></text>=0A</g>=0A<g >=0A<title>__list_add_valid (50,473,508 =
samples, 0.01%)</title><rect x=3D"802.0" y=3D"1813" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(211,228,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"804.97" =
y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpa=
th (175,743,420 samples, 0.05%)</title><rect x=3D"145.7" y=3D"1605" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(222,24,43)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"148.72" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,0=
24,160,904 samples, 0.28%)</title><rect x=3D"33.1" y=3D"1413" width=3D"3.3"=
 height=3D"15.0" fill=3D"rgb(217,29,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"36.10" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock (88,390=
,116 samples, 0.02%)</title><rect x=3D"1182.7" y=3D"1813" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(221,48,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"118=
5.70" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (59,246=
,463 samples, 0.02%)</title><rect x=3D"71.1" y=3D"1429" width=3D"0.2" heigh=
t=3D"15.0" fill=3D"rgb(222,79,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"74.10=
" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>rcu_preempt_need_deferred_qs=
 (59,496,610 samples, 0.02%)</title><rect x=3D"869.1" y=3D"1877" width=3D"0=
.2" height=3D"15.0" fill=3D"rgb(247,34,0)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"872.12" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__kvm_mmu_topup_me=
mory_cache (47,709,271 samples, 0.01%)</title><rect x=3D"11.6" y=3D"37" wid=
th=3D"0.2" height=3D"15.0" fill=3D"rgb(241,46,42)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"14.61" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_f=
ault (2,082,264,609 samples, 0.56%)</title><rect x=3D"42.4" y=3D"1557" widt=
h=3D"6.7" height=3D"15.0" fill=3D"rgb(232,105,26)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"45.42" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>__mod_memcg_=
lruvec_state (175,965,008 samples, 0.05%)</title><rect x=3D"1179.8" y=3D"17=
65" width=3D"0.5" height=3D"15.0" fill=3D"rgb(234,225,2)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"1182.77" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>__s=
chedule (542,728,998 samples, 0.15%)</title><rect x=3D"164.9" y=3D"1637" wi=
dth=3D"1.8" height=3D"15.0" fill=3D"rgb(212,21,14)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"167.93" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_=
unlock_irq (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D"1541"=
 width=3D"0.6" height=3D"15.0" fill=3D"rgb(213,226,45)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"114.26" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>shmem_=
get_folio_gfp (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=3D"1=
17" width=3D"8.0" height=3D"15.0" fill=3D"rgb(240,135,44)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"20.24" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>preem=
pt_count_add (66,499,095 samples, 0.02%)</title><rect x=3D"217.7" y=3D"1877=
" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,113,33)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"220.70" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>__mod=
_lruvec_state (309,327,693 samples, 0.08%)</title><rect x=3D"156.3" y=3D"17=
33" width=3D"1.0" height=3D"15.0" fill=3D"rgb(246,143,17)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"159.29" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>hrt=
imer_interrupt (571,370,498 samples, 0.15%)</title><rect x=3D"1032.4" y=3D"=
1893" width=3D"1.8" height=3D"15.0" fill=3D"rgb(208,217,53)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1035.43" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>=
syscall_exit_to_user_mode (139,850,479 samples, 0.04%)</title><rect x=3D"25=
1.9" y=3D"1989" width=3D"0.5" height=3D"15.0" fill=3D"rgb(214,183,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"254.92" y=3D"1999.5" ></text>=0A</g>=0A<g =
>=0A<title>__x64_sys_ioctl (3,104,413,288 samples, 0.84%)</title><rect x=3D=
"98.7" y=3D"1813" width=3D"9.9" height=3D"15.0" fill=3D"rgb(226,110,6)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"101.67" y=3D"1823.5" ></text>=0A</g>=0A<g =
>=0A<title>kvm_faultin_pfn (1,111,133,729 samples, 0.30%)</title><rect x=3D=
"13.3" y=3D"229" width=3D"3.5" height=3D"15.0" fill=3D"rgb(208,17,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"239.5" ></text>=0A</g>=0A<g >=
=0A<title>folio_mark_accessed (49,126,693 samples, 0.01%)</title><rect x=3D=
"31.5" y=3D"1477" width=3D"0.2" height=3D"15.0" fill=3D"rgb(236,149,2)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"34.54" y=3D"1487.5" ></text>=0A</g>=0A<g >=
=0A<title>vcpu_enter_guest (1,616,765,146 samples, 0.44%)</title><rect x=3D=
"88.2" y=3D"1733" width=3D"5.1" height=3D"15.0" fill=3D"rgb(253,86,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"91.17" y=3D"1743.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_tdp_page_fault (1,100,658,368 samples, 0.30%)</title><rect x=
=3D"33.0" y=3D"1525" width=3D"3.5" height=3D"15.0" fill=3D"rgb(238,8,19)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"35.98" y=3D"1535.5" ></text>=0A</g>=0A<g =
>=0A<title>do_syscall_64 (145,741,482 samples, 0.04%)</title><rect x=3D"25.=
2" y=3D"405" width=3D"0.4" height=3D"15.0" fill=3D"rgb(250,49,3)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"28.18" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<titl=
e>syscall_return_via_sysret (398,509,546 samples, 0.11%)</title><rect x=3D"=
432.5" y=3D"2021" width=3D"1.3" height=3D"15.0" fill=3D"rgb(210,3,43)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"435.53" y=3D"2031.5" ></text>=0A</g>=0A<g =
>=0A<title>dequeue_task_fair (310,476,759 samples, 0.08%)</title><rect x=3D=
"91.1" y=3D"1461" width=3D"0.9" height=3D"15.0" fill=3D"rgb(246,187,26)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"94.06" y=3D"1471.5" ></text>=0A</g>=0A<g >=
=0A<title>__x64_sys_ioctl (1,688,676,626 samples, 0.46%)</title><rect x=3D"=
32.2" y=3D"1621" width=3D"5.4" height=3D"15.0" fill=3D"rgb(227,25,0)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"35.23" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A=
<title>__handle_mm_fault (1,465,325,974 samples, 0.40%)</title><rect x=3D"1=
42.3" y=3D"1717" width=3D"4.7" height=3D"15.0" fill=3D"rgb(239,78,19)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"145.32" y=3D"1727.5" ></text>=0A</g>=0A<g =
>=0A<title>vmx_vcpu_run (54,308,608 samples, 0.01%)</title><rect x=3D"73.9"=
 y=3D"1653" width=3D"0.2" height=3D"15.0" fill=3D"rgb(254,107,49)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"76.90" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>kvm_vcpu_ioctl (1,657,361,967 samples, 0.45%)</title><rect x=3D"93.4" y=
=3D"1781" width=3D"5.3" height=3D"15.0" fill=3D"rgb(234,8,28)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"96.39" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title=
>__rcu_read_unlock (100,826,405 samples, 0.03%)</title><rect x=3D"798.3" y=
=3D"1861" width=3D"0.4" height=3D"15.0" fill=3D"rgb(237,64,16)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"801.35" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<titl=
e>shmem_fault (1,012,875,001 samples, 0.27%)</title><rect x=3D"33.1" y=3D"1=
381" width=3D"3.3" height=3D"15.0" fill=3D"rgb(224,207,11)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"36.13" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>nat=
ive_queued_spin_lock_slowpath (1,286,797,459 samples, 0.35%)</title><rect x=
=3D"100.6" y=3D"1477" width=3D"4.1" height=3D"15.0" fill=3D"rgb(227,224,39)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"103.63" y=3D"1487.5" ></text>=0A</g>=
=0A<g >=0A<title>_raw_spin_unlock (476,164,467 samples, 0.13%)</title><rect=
 x=3D"758.2" y=3D"1653" width=3D"1.5" height=3D"15.0" fill=3D"rgb(219,29,18=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"761.16" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (182,037,942 samples, 0.05%)</titl=
e><rect x=3D"12.7" y=3D"277" width=3D"0.6" height=3D"15.0" fill=3D"rgb(253,=
19,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"287.5" ></text>=0A</g=
>=0A<g >=0A<title>truncate_cleanup_folio (66,208,753 samples, 0.02%)</title=
><rect x=3D"1183.5" y=3D"1829" width=3D"0.3" height=3D"15.0" fill=3D"rgb(21=
4,148,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.55" y=3D"1839.5" ></text=
>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (160,833,494 sampl=
es, 0.04%)</title><rect x=3D"834.2" y=3D"1909" width=3D"0.5" height=3D"15.0=
" fill=3D"rgb(227,212,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1=
919.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (1,423,413,484=
 samples, 0.38%)</title><rect x=3D"160.3" y=3D"1653" width=3D"4.5" height=
=3D"15.0" fill=3D"rgb(226,8,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26"=
 y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (795,=
859,962 samples, 0.21%)</title><rect x=3D"128.2" y=3D"1733" width=3D"2.6" h=
eight=3D"15.0" fill=3D"rgb(246,52,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
31.24" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (133=
,987,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"277" width=3D"0.4" he=
ight=3D"15.0" fill=3D"rgb(238,130,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
9.81" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>mtree_range_walk (117,015=
,914 samples, 0.03%)</title><rect x=3D"37.7" y=3D"1413" width=3D"0.4" heigh=
t=3D"15.0" fill=3D"rgb(231,45,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.74=
" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>clock_gettime@GLIBC_2.2.5 (3=
73,695,443 samples, 0.10%)</title><rect x=3D"434.5" y=3D"2021" width=3D"1.2=
" height=3D"15.0" fill=3D"rgb(241,204,54)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"437.55" y=3D"2031.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1=
45,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"277" width=3D"0.4" =
height=3D"15.0" fill=3D"rgb(212,16,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
28.18" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (2,63=
2,189,638 samples, 0.71%)</title><rect x=3D"158.3" y=3D"1861" width=3D"8.4"=
 height=3D"15.0" fill=3D"rgb(239,111,32)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"161.30" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (61,7=
57,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"485" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(217,74,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.0=
0" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_state (110,374,=
308 samples, 0.03%)</title><rect x=3D"1179.4" y=3D"1765" width=3D"0.4" heig=
ht=3D"15.0" fill=3D"rgb(248,130,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"118=
2.42" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release_pfn_clean (8=
68,067,535 samples, 0.23%)</title><rect x=3D"808.4" y=3D"1893" width=3D"2.7=
" height=3D"15.0" fill=3D"rgb(213,60,26)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"811.37" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>bad_range (66,444,=
623 samples, 0.02%)</title><rect x=3D"1176.8" y=3D"1765" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(229,114,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"117=
9.82" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only=
 (3,931,883,555 samples, 1.06%)</title><rect x=3D"470.3" y=3D"1861" width=
=3D"12.5" height=3D"15.0" fill=3D"rgb(232,227,7)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"473.27" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_api=
c_timer_interrupt (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=
=3D"1493" width=3D"0.6" height=3D"15.0" fill=3D"rgb(249,78,19)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"114.26" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<titl=
e>psi_task_switch (63,623,466 samples, 0.02%)</title><rect x=3D"146.8" y=3D=
"1589" width=3D"0.2" height=3D"15.0" fill=3D"rgb(212,144,6)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"149.78" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>_=
raw_spin_lock_irqsave (628,142,401 samples, 0.17%)</title><rect x=3D"143.7"=
 y=3D"1605" width=3D"2.0" height=3D"15.0" fill=3D"rgb(213,189,47)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"146.71" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<t=
itle>folio_unlock (245,491,827 samples, 0.07%)</title><rect x=3D"510.8" y=
=3D"1733" width=3D"0.8" height=3D"15.0" fill=3D"rgb(246,95,46)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"513.78" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_vcpu_ioctl (2,637,779,941 samples, 0.71%)</title><rect x=3D"112.8" y=
=3D"1829" width=3D"8.4" height=3D"15.0" fill=3D"rgb(213,93,31)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"115.85" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<titl=
e>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"965=
" width=3D"19.2" height=3D"15.0" fill=3D"rgb(220,191,18)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"13.00" y=3D"975.5" ></text>=0A</g>=0A<g >=0A<title>[unkno=
wn] (23,375,267,582 samples, 6.31%)</title><rect x=3D"10.0" y=3D"1813" widt=
h=3D"74.5" height=3D"15.0" fill=3D"rgb(246,59,41)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"13.00" y=3D"1823.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>__h=
rtimer_run_queues (49,270,795 samples, 0.01%)</title><rect x=3D"706.3" y=3D=
"1637" width=3D"0.1" height=3D"15.0" fill=3D"rgb(231,127,37)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"709.27" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_raw_spin_lock (39,330,909 samples, 0.01%)</title><rect x=3D"143.6" y=
=3D"1541" width=3D"0.1" height=3D"15.0" fill=3D"rgb(234,128,30)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"146.59" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<tit=
le>do_raw_spin_lock (1,136,286,143 samples, 0.31%)</title><rect x=3D"530.6"=
 y=3D"1637" width=3D"3.6" height=3D"15.0" fill=3D"rgb(207,34,36)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"533.61" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>do_raw_spin_lock (1,663,082,890 samples, 0.45%)</title><rect x=3D"132.6=
" y=3D"1573" width=3D"5.3" height=3D"15.0" fill=3D"rgb(215,128,53)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<=
title>do_raw_spin_unlock (44,186,099 samples, 0.01%)</title><rect x=3D"1183=
.1" y=3D"1797" width=3D"0.1" height=3D"15.0" fill=3D"rgb(253,42,27)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1186.05" y=3D"1807.5" ></text>=0A</g>=0A<g >=
=0A<title>userfaultfd_ioctl (6,046,009,306 samples, 1.63%)</title><rect x=
=3D"876.5" y=3D"1989" width=3D"19.3" height=3D"15.0" fill=3D"rgb(221,51,28)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"879.51" y=3D"1999.5" ></text>=0A</g>=
=0A<g >=0A<title>__x64_sys_ioctl (1,111,133,729 samples, 0.30%)</title><rec=
t x=3D"13.3" y=3D"341" width=3D"3.5" height=3D"15.0" fill=3D"rgb(240,225,17=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"351.5" ></text>=0A</g>=0A=
<g >=0A<title>native_queued_spin_lock_slowpath (993,176,439 samples, 0.27%)=
</title><rect x=3D"13.6" y=3D"37" width=3D"3.2" height=3D"15.0" fill=3D"rgb=
(242,216,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.65" y=3D"47.5" ></text>=
=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,112,111,832 samples, 0.30%)<=
/title><rect x=3D"168.5" y=3D"1701" width=3D"3.6" height=3D"15.0" fill=3D"r=
gb(207,217,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.53" y=3D"1711.5" ></=
text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,064,009,009 samples, 0.29=
%)</title><rect x=3D"50.4" y=3D"1477" width=3D"3.4" height=3D"15.0" fill=3D=
"rgb(231,27,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.40" y=3D"1487.5" ></=
text>=0A</g>=0A<g >=0A<title>do_vfs_ioctl (44,325,484 samples, 0.01%)</titl=
e><rect x=3D"449.7" y=3D"1989" width=3D"0.2" height=3D"15.0" fill=3D"rgb(21=
3,173,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"452.74" y=3D"1999.5" ></text>=
=0A</g>=0A<g >=0A<title>mt_find (59,449,801 samples, 0.02%)</title><rect x=
=3D"12.5" y=3D"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,135,31)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"15.50" y=3D"47.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_vcpu_ioctl (1,850,870,166 samples, 0.50%)</title><rect x=3D"1=
84.1" y=3D"1973" width=3D"5.9" height=3D"15.0" fill=3D"rgb(210,74,8)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"187.13" y=3D"1983.5" ></text>=0A</g>=0A<g >=
=0A<title>schedule (542,728,998 samples, 0.15%)</title><rect x=3D"164.9" y=
=3D"1653" width=3D"1.8" height=3D"15.0" fill=3D"rgb(233,95,20)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"167.93" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_arch_vcpu_ioctl_run (1,111,133,729 samples, 0.30%)</title><rect x=3D"=
13.3" y=3D"309" width=3D"3.5" height=3D"15.0" fill=3D"rgb(242,154,23)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>syscall_enter_from_user_mode (44,325,750 samples, 0.01%)</title><=
rect x=3D"431.7" y=3D"1989" width=3D"0.1" height=3D"15.0" fill=3D"rgb(216,3=
9,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434.68" y=3D"1999.5" ></text>=0A<=
/g>=0A<g >=0A<title>__schedule (61,757,117 samples, 0.02%)</title><rect x=
=3D"29.0" y=3D"133" width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,97,35)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"143.5" ></text>=0A</g>=0A<g >=
=0A<title>__x64_sys_munmap (1,619,511,008 samples, 0.44%)</title><rect x=3D=
"1183.8" y=3D"1989" width=3D"5.1" height=3D"15.0" fill=3D"rgb(216,228,11)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.76" y=3D"1999.5" ></text>=0A</g>=0A=
<g >=0A<title>hva_to_pfn (1,410,897,962 samples, 0.38%)</title><rect x=3D"7=
4.2" y=3D"1605" width=3D"4.5" height=3D"15.0" fill=3D"rgb(233,146,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"77.18" y=3D"1615.5" ></text>=0A</g>=0A<g >=
=0A<title>preempt_count_add (44,337,929 samples, 0.01%)</title><rect x=3D"8=
83.3" y=3D"1941" width=3D"0.1" height=3D"15.0" fill=3D"rgb(243,79,51)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"886.31" y=3D"1951.5" ></text>=0A</g>=0A<g =
>=0A<title>put_prev_task_fair (51,263,533 samples, 0.01%)</title><rect x=3D=
"776.2" y=3D"1685" width=3D"0.1" height=3D"15.0" fill=3D"rgb(228,164,23)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"779.17" y=3D"1695.5" ></text>=0A</g>=0A<g=
 >=0A<title>kvm_tdp_page_fault (1,778,957,439 samples, 0.48%)</title><rect =
x=3D"68.2" y=3D"1621" width=3D"5.7" height=3D"15.0" fill=3D"rgb(251,109,32)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1631.5" ></text>=0A</g>=0A=
<g >=0A<title>__get_user_pages (264,013,792 samples, 0.07%)</title><rect x=
=3D"25.6" y=3D"245" width=3D"0.9" height=3D"15.0" fill=3D"rgb(226,51,17)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"255.5" ></text>=0A</g>=0A<g >=
=0A<title>vmx_vcpu_run (159,314,940 samples, 0.04%)</title><rect x=3D"10.8"=
 y=3D"69" width=3D"0.5" height=3D"15.0" fill=3D"rgb(248,31,0)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.80" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>e=
ntry_SYSCALL_64 (1,657,361,967 samples, 0.45%)</title><rect x=3D"93.4" y=3D=
"1829" width=3D"5.3" height=3D"15.0" fill=3D"rgb(217,108,30)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"96.39" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title=
>hva_to_pfn (2,719,092,456 samples, 0.73%)</title><rect x=3D"147.6" y=3D"17=
97" width=3D"8.7" height=3D"15.0" fill=3D"rgb(226,15,10)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"150.63" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>chan=
ge_prot_numa (41,394,896 samples, 0.01%)</title><rect x=3D"875.4" y=3D"1909=
" width=3D"0.1" height=3D"15.0" fill=3D"rgb(247,68,5)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"878.39" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu=
_page_fault (1,142,740,434 samples, 0.31%)</title><rect x=3D"109.0" y=3D"17=
49" width=3D"3.7" height=3D"15.0" fill=3D"rgb(205,55,25)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"112.02" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>chec=
k_preemption_disabled (203,226,416 samples, 0.05%)</title><rect x=3D"66.5" =
y=3D"1541" width=3D"0.6" height=3D"15.0" fill=3D"rgb(232,14,25)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"69.50" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_syscall_64 (1,688,676,626 samples, 0.46%)</title><rect x=3D"32.2" y=3D=
"1637" width=3D"5.4" height=3D"15.0" fill=3D"rgb(246,35,29)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"35.23" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>kv=
m_arch_vcpu_load (143,690,636 samples, 0.04%)</title><rect x=3D"146.3" y=3D=
"1573" width=3D"0.5" height=3D"15.0" fill=3D"rgb(236,147,50)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"149.33" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_syscall_64 (1,319,411,362 samples, 0.36%)</title><rect x=3D"49.8" y=3D=
"1685" width=3D"4.2" height=3D"15.0" fill=3D"rgb(222,72,26)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"52.75" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>en=
try_SYSCALL_64 (1,539,194,524 samples, 0.42%)</title><rect x=3D"167.5" y=3D=
"1989" width=3D"4.9" height=3D"15.0" fill=3D"rgb(230,182,41)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"170.50" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<titl=
e>get_user_pages_unlocked (1,422,286,997 samples, 0.38%)</title><rect x=3D"=
37.7" y=3D"1493" width=3D"4.6" height=3D"15.0" fill=3D"rgb(231,171,7)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1503.5" ></text>=0A</g>=0A<g >=
=0A<title>do_raw_spin_lock (845,221,885 samples, 0.23%)</title><rect x=3D"5=
5.2" y=3D"1365" width=3D"2.6" height=3D"15.0" fill=3D"rgb(251,44,39)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"58.16" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A=
<title>folio_mark_accessed (282,804,178 samples, 0.08%)</title><rect x=3D"1=
27.1" y=3D"1733" width=3D"0.9" height=3D"15.0" fill=3D"rgb(243,99,20)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"130.07" y=3D"1743.5" ></text>=0A</g>=0A<g =
>=0A<title>dequeue_entity (159,609,926 samples, 0.04%)</title><rect x=3D"77=
.4" y=3D"1397" width=3D"0.5" height=3D"15.0" fill=3D"rgb(218,131,50)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"80.39" y=3D"1407.5" ></text>=0A</g>=0A<g >=0A=
<title>__x64_sys_ioctl (1,655,662,953 samples, 0.45%)</title><rect x=3D"142=
.3" y=3D"1909" width=3D"5.2" height=3D"15.0" fill=3D"rgb(252,191,25)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"145.27" y=3D"1919.5" ></text>=0A</g>=0A<g >=
=0A<title>entry_SYSCALL_64 (1,619,511,008 samples, 0.44%)</title><rect x=3D=
"1183.8" y=3D"2021" width=3D"5.1" height=3D"15.0" fill=3D"rgb(220,220,12)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.76" y=3D"2031.5" ></text>=0A</g>=0A=
<g >=0A<title>do_syscall_64 (182,037,942 samples, 0.05%)</title><rect x=3D"=
12.7" y=3D"325" width=3D"0.6" height=3D"15.0" fill=3D"rgb(251,86,20)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<=
title>do_fault (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"18=
1" width=3D"0.4" height=3D"15.0" fill=3D"rgb(231,13,36)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"28.18" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>do_sysc=
all_64 (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"437" width=
=3D"2.5" height=3D"15.0" fill=3D"rgb(210,100,10)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"29.48" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>task_work_run =
(132,959,376 samples, 0.04%)</title><rect x=3D"1170.9" y=3D"1973" width=3D"=
0.4" height=3D"15.0" fill=3D"rgb(243,124,21)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1173.87" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_unl=
ock (44,324,277 samples, 0.01%)</title><rect x=3D"226.3" y=3D"1909" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(251,157,50)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"229.30" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_=
lock (184,955,698 samples, 0.05%)</title><rect x=3D"89.0" y=3D"1461" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(247,204,1)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"91.97" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_comm=
on_lock (787,893,108 samples, 0.21%)</title><rect x=3D"94.0" y=3D"1509" wid=
th=3D"2.5" height=3D"15.0" fill=3D"rgb(250,106,46)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"97.00" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>psi_task_sw=
itch (36,991,698 samples, 0.01%)</title><rect x=3D"36.2" y=3D"1301" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(229,139,0)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"39.23" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_=
queues (47,348,631 samples, 0.01%)</title><rect x=3D"706.7" y=3D"1653" widt=
h=3D"0.1" height=3D"15.0" fill=3D"rgb(230,15,23)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"709.65" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_p=
ages (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"85" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(211,222,5)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"15.50" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_l=
ock_slowpath (470,679,882 samples, 0.13%)</title><rect x=3D"89.6" y=3D"1477=
" width=3D"1.5" height=3D"15.0" fill=3D"rgb(210,94,32)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"92.56" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>securit=
y_file_ioctl (310,430,379 samples, 0.08%)</title><rect x=3D"875.5" y=3D"198=
9" width=3D"1.0" height=3D"15.0" fill=3D"rgb(219,61,30)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"878.52" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>handl=
e_mm_fault (1,283,044,033 samples, 0.35%)</title><rect x=3D"38.2" y=3D"1461=
" width=3D"4.1" height=3D"15.0" fill=3D"rgb(219,35,15)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"41.17" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_unlock_irqrestore (88,942,411 samples, 0.02%)</title><rect x=3D"534.2" y=
=3D"1653" width=3D"0.3" height=3D"15.0" fill=3D"rgb(221,229,52)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"537.23" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<tit=
le>_raw_spin_lock_irqsave (1,211,848,231 samples, 0.33%)</title><rect x=3D"=
185.9" y=3D"1685" width=3D"3.8" height=3D"15.0" fill=3D"rgb(249,193,42)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"188.87" y=3D"1695.5" ></text>=0A</g>=0A<g =
>=0A<title>__wake_userfault (17,345,428,968 samples, 4.68%)</title><rect x=
=3D"193.3" y=3D"1957" width=3D"55.3" height=3D"15.0" fill=3D"rgb(248,43,23)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"196.30" y=3D"1967.5" >__wak..</text>=
=0A</g>=0A<g >=0A<title>__filemap_get_folio (196,384,866 samples, 0.05%)</t=
itle><rect x=3D"74.3" y=3D"1461" width=3D"0.6" height=3D"15.0" fill=3D"rgb(=
252,166,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.30" y=3D"1471.5" ></text=
>=0A</g>=0A<g >=0A<title>__schedule (42,771,079 samples, 0.01%)</title><rec=
t x=3D"126.9" y=3D"1557" width=3D"0.2" height=3D"15.0" fill=3D"rgb(206,50,4=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"129.93" y=3D"1567.5" ></text>=0A</g>=
=0A<g >=0A<title>do_fault (2,491,551,090 samples, 0.67%)</title><rect x=3D"=
17.2" y=3D"165" width=3D"8.0" height=3D"15.0" fill=3D"rgb(233,32,31)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<=
title>do_raw_spin_lock (75,995,114 samples, 0.02%)</title><rect x=3D"96.5" =
y=3D"1509" width=3D"0.3" height=3D"15.0" fill=3D"rgb(219,93,13)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"99.51" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<titl=
e>tick_sched_handle.isra.21 (110,812,663 samples, 0.03%)</title><rect x=3D"=
274.0" y=3D"1829" width=3D"0.3" height=3D"15.0" fill=3D"rgb(229,53,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"276.99" y=3D"1839.5" ></text>=0A</g>=0A<g =
>=0A<title>__get_user_pages (777,956,492 samples, 0.21%)</title><rect x=3D"=
128.2" y=3D"1717" width=3D"2.5" height=3D"15.0" fill=3D"rgb(226,188,53)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"131.24" y=3D"1727.5" ></text>=0A</g>=0A<g =
>=0A<title>__wake_up_common (261,868,931 samples, 0.07%)</title><rect x=3D"=
94.0" y=3D"1493" width=3D"0.8" height=3D"15.0" fill=3D"rgb(230,100,15)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"97.00" y=3D"1503.5" ></text>=0A</g>=0A<g >=
=0A<title>handle_userfault (2,007,086,022 samples, 0.54%)</title><rect x=3D=
"160.3" y=3D"1669" width=3D"6.4" height=3D"15.0" fill=3D"rgb(247,13,24)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=3D"1679.5" ></text>=0A</g>=0A<g =
>=0A<title>get_user_pages_fast_only (164,415,151 samples, 0.04%)</title><re=
ct x=3D"184.2" y=3D"1845" width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,24,=
46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"187.23" y=3D"1855.5" ></text>=0A</g=
>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=
=3D"10.0" y=3D"1253" width=3D"19.2" height=3D"15.0" fill=3D"rgb(221,151,13)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1263.5" ></text>=0A</g>=0A=
<g >=0A<title>kvm_arch_vcpu_ioctl_run (123,122,609 samples, 0.03%)</title><=
rect x=3D"11.4" y=3D"133" width=3D"0.4" height=3D"15.0" fill=3D"rgb(240,113=
,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"143.5" ></text>=0A</g>=
=0A<g >=0A<title>vcpu_enter_guest (2,637,779,941 samples, 0.71%)</title><re=
ct x=3D"112.8" y=3D"1797" width=3D"8.4" height=3D"15.0" fill=3D"rgb(233,194=
,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.85" y=3D"1807.5" ></text>=0A</g=
>=0A<g >=0A<title>__update_load_avg_se (140,037,292 samples, 0.04%)</title>=
<rect x=3D"755.2" y=3D"1637" width=3D"0.4" height=3D"15.0" fill=3D"rgb(238,=
91,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"758.17" y=3D"1647.5" ></text>=0A<=
/g>=0A<g >=0A<title>[kvm-intel.ko] (315,491,762 samples, 0.09%)</title><rec=
t x=3D"131.5" y=3D"1797" width=3D"1.0" height=3D"15.0" fill=3D"rgb(230,84,7=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"134.51" y=3D"1807.5" ></text>=0A</g>=
=0A<g >=0A<title>_raw_spin_unlock_irqrestore (398,938,835 samples, 0.11%)</=
title><rect x=3D"903.1" y=3D"1957" width=3D"1.3" height=3D"15.0" fill=3D"rg=
b(206,197,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.12" y=3D"1967.5" ></t=
ext>=0A</g>=0A<g >=0A<title>kvm_wait_lapic_expire (401,275,550 samples, 0.1=
1%)</title><rect x=3D"871.6" y=3D"1925" width=3D"1.3" height=3D"15.0" fill=
=3D"rgb(221,219,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"874.59" y=3D"1935.5=
" ></text>=0A</g>=0A<g >=0A<title>handle_uffd_page_request (44,743,851 samp=
les, 0.01%)</title><rect x=3D"435.7" y=3D"2037" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(230,64,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"438.74" y=3D"=
2047.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (44,310,216 samp=
les, 0.01%)</title><rect x=3D"217.4" y=3D"1861" width=3D"0.2" height=3D"15.=
0" fill=3D"rgb(209,97,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"220.41" y=3D"=
1871.5" ></text>=0A</g>=0A<g >=0A<title>__filemap_remove_folio (1,141,314,5=
08 samples, 0.31%)</title><rect x=3D"1179.1" y=3D"1813" width=3D"3.6" heigh=
t=3D"15.0" fill=3D"rgb(217,34,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.=
07" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>psi_account_irqtime (43,69=
9,070 samples, 0.01%)</title><rect x=3D"98.2" y=3D"1461" width=3D"0.1" heig=
ht=3D"15.0" fill=3D"rgb(253,173,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101=
.17" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (1,678,566,15=
8 samples, 0.45%)</title><rect x=3D"173.4" y=3D"1733" width=3D"5.4" height=
=3D"15.0" fill=3D"rgb(213,122,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.45=
" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt =
(177,301,772 samples, 0.05%)</title><rect x=3D"273.9" y=3D"1909" width=3D"0=
.6" height=3D"15.0" fill=3D"rgb(226,35,32)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"276.91" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__this_cpu_preempt=
_check (44,328,381 samples, 0.01%)</title><rect x=3D"1188.1" y=3D"1781" wid=
th=3D"0.1" height=3D"15.0" fill=3D"rgb(218,197,20)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1191.07" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>native_qu=
eued_spin_lock_slowpath (44,098,602 samples, 0.01%)</title><rect x=3D"897.2=
" y=3D"1781" width=3D"0.1" height=3D"15.0" fill=3D"rgb(209,178,22)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"900.19" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<=
title>gup_pgd_range (336,537,251 samples, 0.09%)</title><rect x=3D"158.3" y=
=3D"1765" width=3D"1.1" height=3D"15.0" fill=3D"rgb(231,24,21)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"161.30" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<titl=
e>[unknown] (135,077,187,157 samples, 36.47%)</title><rect x=3D"10.0" y=3D"=
2053" width=3D"430.3" height=3D"15.0" fill=3D"rgb(236,71,38)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"2063.5" >[unknown]</text>=0A</g>=0A<g >=
=0A<title>[kvm-intel.ko] (46,392,999 samples, 0.01%)</title><rect x=3D"178.=
9" y=3D"1893" width=3D"0.1" height=3D"15.0" fill=3D"rgb(224,54,5)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"181.88" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<t=
itle>kvm_mmu_page_fault (1,226,612,664 samples, 0.33%)</title><rect x=3D"55=
.0" y=3D"1605" width=3D"3.9" height=3D"15.0" fill=3D"rgb(208,166,19)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"57.96" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A=
<title>folio_activate (196,324,174 samples, 0.05%)</title><rect x=3D"73.1" =
y=3D"1573" width=3D"0.6" height=3D"15.0" fill=3D"rgb(228,152,14)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"76.06" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<tit=
le>[unknown] (6,025,491,669 samples, 1.63%)</title><rect x=3D"10.0" y=3D"50=
1" width=3D"19.2" height=3D"15.0" fill=3D"rgb(222,34,49)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"13.00" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>check_=
preemption_disabled (47,009,228 samples, 0.01%)</title><rect x=3D"798.7" y=
=3D"1845" width=3D"0.2" height=3D"15.0" fill=3D"rgb(244,42,12)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"801.73" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<titl=
e>get_user_pages_unlocked (133,987,142 samples, 0.04%)</title><rect x=3D"16=
.8" y=3D"213" width=3D"0.4" height=3D"15.0" fill=3D"rgb(239,198,51)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<t=
itle>native_queued_spin_lock_slowpath (2,344,242,284 samples, 0.63%)</title=
><rect x=3D"17.2" y=3D"37" width=3D"7.5" height=3D"15.0" fill=3D"rgb(224,19=
8,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"47.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"709" width=3D"19.2" height=3D"15.0" fill=3D"rgb(211,205,32)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"719.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_arch_vcpu_ioctl_run (2,305,287,529 samples, 0.62%)</title><re=
ct x=3D"42.4" y=3D"1621" width=3D"7.4" height=3D"15.0" fill=3D"rgb(219,180,=
39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1631.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"725" width=3D"19.2" height=3D"15.0" fill=3D"rgb(223,81,5)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"735.5" ></text>=0A</g>=0A<g >=
=0A<title>__x64_sys_ioctl (1,833,266,047 samples, 0.49%)</title><rect x=3D"=
68.2" y=3D"1717" width=3D"5.9" height=3D"15.0" fill=3D"rgb(227,154,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"1727.5" ></text>=0A</g>=0A<g >=
=0A<title>schedule (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=
=3D"101" width=3D"0.4" height=3D"15.0" fill=3D"rgb(250,78,48)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"28.18" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>=
__GI___ioctl (1,678,460,921 samples, 0.45%)</title><rect x=3D"93.3" y=3D"18=
45" width=3D"5.4" height=3D"15.0" fill=3D"rgb(225,173,31)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"96.32" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>__ha=
ndle_mm_fault (1,417,843,408 samples, 0.38%)</title><rect x=3D"42.9" y=3D"1=
461" width=3D"4.5" height=3D"15.0" fill=3D"rgb(244,31,7)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"45.86" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__han=
dle_mm_fault (948,421,280 samples, 0.26%)</title><rect x=3D"81.1" y=3D"1557=
" width=3D"3.0" height=3D"15.0" fill=3D"rgb(232,94,28)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"84.08" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_unlock_irqrestore (191,048,745 samples, 0.05%)</title><rect x=3D"151.0" =
y=3D"1573" width=3D"0.7" height=3D"15.0" fill=3D"rgb(226,213,43)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"154.05" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>vcpu_enter_guest (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=
=3D"149" width=3D"0.3" height=3D"15.0" fill=3D"rgb(225,115,25)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"15.08" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>=
native_queued_spin_lock_slowpath (257,550,377 samples, 0.07%)</title><rect =
x=3D"46.5" y=3D"1349" width=3D"0.8" height=3D"15.0" fill=3D"rgb(242,3,22)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"49.52" y=3D"1359.5" ></text>=0A</g>=0A<g=
 >=0A<title>__mod_node_page_state (67,773,393 samples, 0.02%)</title><rect =
x=3D"802.2" y=3D"1797" width=3D"0.2" height=3D"15.0" fill=3D"rgb(252,225,50=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"805.19" y=3D"1807.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"901" width=3D"19.2" height=3D"15.0" fill=3D"rgb(206,22,34)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"911.5" ></text>=0A</g>=0A<g >=
=0A<title>__wake_up_common_lock (184,955,698 samples, 0.05%)</title><rect x=
=3D"89.0" y=3D"1493" width=3D"0.6" height=3D"15.0" fill=3D"rgb(240,107,0)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.97" y=3D"1503.5" ></text>=0A</g>=0A<g=
 >=0A<title>tick_sched_timer (110,812,663 samples, 0.03%)</title><rect x=3D=
"274.0" y=3D"1845" width=3D"0.3" height=3D"15.0" fill=3D"rgb(219,188,49)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"276.99" y=3D"1855.5" ></text>=0A</g>=0A<g=
 >=0A<title>__get_user_pages (1,110,100,025 samples, 0.30%)</title><rect x=
=3D"109.1" y=3D"1669" width=3D"3.5" height=3D"15.0" fill=3D"rgb(243,14,41)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.07" y=3D"1679.5" ></text>=0A</g>=0A=
<g >=0A<title>__do_fault (1,075,357,417 samples, 0.29%)</title><rect x=3D"6=
8.8" y=3D"1493" width=3D"3.5" height=3D"15.0" fill=3D"rgb(206,135,10)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"71.83" y=3D"1503.5" ></text>=0A</g>=0A<g >=
=0A<title>mt_find (827,494,144 samples, 0.22%)</title><rect x=3D"484.5" y=
=3D"1797" width=3D"2.6" height=3D"15.0" fill=3D"rgb(252,116,54)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"487.47" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<tit=
le>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"74=
1" width=3D"19.2" height=3D"15.0" fill=3D"rgb(236,29,53)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"13.00" y=3D"751.5" ></text>=0A</g>=0A<g >=0A<title>native=
_queued_spin_lock_slowpath (1,491,492,392 samples, 0.40%)</title><rect x=3D=
"133.1" y=3D"1557" width=3D"4.8" height=3D"15.0" fill=3D"rgb(220,136,43)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"136.13" y=3D"1567.5" ></text>=0A</g>=0A<g=
 >=0A<title>do_raw_spin_lock (528,453,476 samples, 0.14%)</title><rect x=3D=
"169.1" y=3D"1637" width=3D"1.6" height=3D"15.0" fill=3D"rgb(250,226,35)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"172.05" y=3D"1647.5" ></text>=0A</g>=0A<g=
 >=0A<title>get_user_pages_unlocked (2,291,506,301 samples, 0.62%)</title><=
rect x=3D"159.4" y=3D"1797" width=3D"7.3" height=3D"15.0" fill=3D"rgb(223,1=
52,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"162.37" y=3D"1807.5" ></text>=0A=
</g>=0A<g >=0A<title>mcopy_continue (731,530,811 samples, 0.20%)</title><re=
ct x=3D"248.9" y=3D"1957" width=3D"2.4" height=3D"15.0" fill=3D"rgb(215,176=
,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"251.94" y=3D"1967.5" ></text>=0A</=
g>=0A<g >=0A<title>handle_mm_fault (1,236,031,354 samples, 0.33%)</title><r=
ect x=3D"88.4" y=3D"1605" width=3D"3.9" height=3D"15.0" fill=3D"rgb(229,62,=
47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.36" y=3D"1615.5" ></text>=0A</g>=
=0A<g >=0A<title>pick_next_task_fair (1,134,215,540 samples, 0.31%)</title>=
<rect x=3D"766.7" y=3D"1685" width=3D"3.6" height=3D"15.0" fill=3D"rgb(254,=
196,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"769.70" y=3D"1695.5" ></text>=
=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><re=
ct x=3D"10.0" y=3D"1397" width=3D"19.2" height=3D"15.0" fill=3D"rgb(223,224=
,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1407.5" ></text>=0A</g=
>=0A<g >=0A<title>_raw_spin_unlock_irq (120,570,482 samples, 0.03%)</title>=
<rect x=3D"248.6" y=3D"1957" width=3D"0.3" height=3D"15.0" fill=3D"rgb(240,=
167,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"251.56" y=3D"1967.5" ></text>=0A=
</g>=0A<g >=0A<title>shmem_get_folio_gfp (88,847,141,654 samples, 23.99%)</=
title><rect x=3D"500.3" y=3D"1749" width=3D"283.1" height=3D"15.0" fill=3D"=
rgb(205,110,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"503.31" y=3D"1759.5" >s=
hmem_get_folio_gfp</text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 s=
amples, 1.63%)</title><rect x=3D"10.0" y=3D"1461" width=3D"19.2" height=3D"=
15.0" fill=3D"rgb(240,144,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (264,013,792=
 samples, 0.07%)</title><rect x=3D"25.6" y=3D"309" width=3D"0.9" height=3D"=
15.0" fill=3D"rgb(217,104,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=
=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>cgroup_rstat_updated (287,224,20=
7 samples, 0.08%)</title><rect x=3D"91.1" y=3D"1397" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(253,203,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"94.13"=
 y=3D"1407.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (304,120,856 sampl=
es, 0.08%)</title><rect x=3D"71.3" y=3D"1413" width=3D"1.0" height=3D"15.0"=
 fill=3D"rgb(248,195,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"74.29" y=3D"14=
23.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.6=
3%)</title><rect x=3D"10.0" y=3D"1157" width=3D"19.2" height=3D"15.0" fill=
=3D"rgb(227,215,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1167.5"=
 ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</=
title><rect x=3D"10.0" y=3D"1317" width=3D"19.2" height=3D"15.0" fill=3D"rg=
b(214,46,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1327.5" ></tex=
t>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (219,093,086 samples,=
 0.06%)</title><rect x=3D"782.0" y=3D"1669" width=3D"0.7" height=3D"15.0" f=
ill=3D"rgb(250,185,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=3D"1679=
.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,373,790,402 samp=
les, 0.37%)</title><rect x=3D"74.3" y=3D"1477" width=3D"4.4" height=3D"15.0=
" fill=3D"rgb(208,85,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.30" y=3D"14=
87.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (1,130,876,164 =
samples, 0.31%)</title><rect x=3D"173.4" y=3D"1685" width=3D"3.6" height=3D=
"15.0" fill=3D"rgb(207,39,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.45" y=
=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,479,=
547,035 samples, 0.40%)</title><rect x=3D"142.3" y=3D"1765" width=3D"4.7" h=
eight=3D"15.0" fill=3D"rgb(227,55,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
45.27" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,772,=
089,566 samples, 0.48%)</title><rect x=3D"184.2" y=3D"1877" width=3D"5.7" h=
eight=3D"15.0" fill=3D"rgb(210,149,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
187.23" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>xas_init_marks (66,340=
,812 samples, 0.02%)</title><rect x=3D"1182.3" y=3D"1781" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(249,91,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"118=
5.28" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>find_vma (874,197,955 sa=
mples, 0.24%)</title><rect x=3D"484.3" y=3D"1813" width=3D"2.8" height=3D"1=
5.0" fill=3D"rgb(237,41,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"487.32" y=
=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (351,897,454 sam=
ples, 0.10%)</title><rect x=3D"36.5" y=3D"1541" width=3D"1.1" height=3D"15.=
0" fill=3D"rgb(216,77,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.49" y=3D"1=
551.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (1,619,511,008 samples=
, 0.44%)</title><rect x=3D"1183.8" y=3D"2005" width=3D"5.1" height=3D"15.0"=
 fill=3D"rgb(205,112,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.76" y=3D"=
2015.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (133,987,142 samples,=
 0.04%)</title><rect x=3D"16.8" y=3D"373" width=3D"0.4" height=3D"15.0" fil=
l=3D"rgb(216,178,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"383.5"=
 ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (133,987,142 samples, 0.04%)</t=
itle><rect x=3D"16.8" y=3D"229" width=3D"0.4" height=3D"15.0" fill=3D"rgb(2=
46,161,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"239.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (3,348,716,533 samples, 0.90%)</title=
><rect x=3D"147.5" y=3D"1941" width=3D"10.7" height=3D"15.0" fill=3D"rgb(24=
3,115,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.55" y=3D"1951.5" ></text>=
=0A</g>=0A<g >=0A<title>__mmu_notifier_invalidate_range_start (41,394,896 s=
amples, 0.01%)</title><rect x=3D"875.4" y=3D"1877" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(236,98,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"878.39" y=
=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (1,833,266,047 sa=
mples, 0.49%)</title><rect x=3D"68.2" y=3D"1733" width=3D"5.9" height=3D"15=
.0" fill=3D"rgb(233,18,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=3D"=
1743.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (643,799,783 samples, 0=
.17%)</title><rect x=3D"29.5" y=3D"1365" width=3D"2.0" height=3D"15.0" fill=
=3D"rgb(224,33,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.48" y=3D"1375.5" =
></text>=0A</g>=0A<g >=0A<title>finish_task_switch (347,088,704 samples, 0.=
09%)</title><rect x=3D"104.9" y=3D"1493" width=3D"1.1" height=3D"15.0" fill=
=3D"rgb(235,28,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"107.94" y=3D"1503.5"=
 ></text>=0A</g>=0A<g >=0A<title>__vmx_vcpu_run_flags (71,886,953 samples, =
0.02%)</title><rect x=3D"870.8" y=3D"1925" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(244,20,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"873.82" y=3D"1935.5=
" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (2,214,703,838 sa=
mples, 0.60%)</title><rect x=3D"99.5" y=3D"1669" width=3D"7.1" height=3D"15=
.0" fill=3D"rgb(218,225,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.55" y=
=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>cgroup_base_stat_cputime_accoun=
t_end.isra.12 (287,224,207 samples, 0.08%)</title><rect x=3D"91.1" y=3D"141=
3" width=3D"0.9" height=3D"15.0" fill=3D"rgb(245,118,2)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"94.13" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>intern=
al_get_user_pages_fast (336,537,251 samples, 0.09%)</title><rect x=3D"158.3=
" y=3D"1781" width=3D"1.1" height=3D"15.0" fill=3D"rgb(224,74,44)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"161.30" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__GI___ioctl (123,051,561 samples, 0.03%)</title><rect x=3D"10.0" y=3D=
"133" width=3D"0.4" height=3D"15.0" fill=3D"rgb(249,211,31)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"13.00" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>[un=
known] (37,099,916,283 samples, 10.02%)</title><rect x=3D"10.0" y=3D"1925" =
width=3D"118.2" height=3D"15.0" fill=3D"rgb(242,193,42)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"13.00" y=3D"1935.5" >[unknown]</text>=0A</g>=0A<g >=0A<tit=
le>vmx_handle_exit (1,778,957,439 samples, 0.48%)</title><rect x=3D"68.2" y=
=3D"1653" width=3D"5.7" height=3D"15.0" fill=3D"rgb(207,166,26)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"71.24" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_raw_spin_lock (1,211,848,231 samples, 0.33%)</title><rect x=3D"185.9" =
y=3D"1669" width=3D"3.8" height=3D"15.0" fill=3D"rgb(210,16,13)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"188.87" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<tit=
le>pollwake (39,330,909 samples, 0.01%)</title><rect x=3D"143.6" y=3D"1589"=
 width=3D"0.1" height=3D"15.0" fill=3D"rgb(223,180,27)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"146.59" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>update=
_rq_clock (155,749,882 samples, 0.04%)</title><rect x=3D"166.2" y=3D"1621" =
width=3D"0.5" height=3D"15.0" fill=3D"rgb(232,91,3)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"169.16" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_=
spin_lock (120,113,565 samples, 0.03%)</title><rect x=3D"138.0" y=3D"1605" =
width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,155,48)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"140.96" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__GI___=
ioctl (143,138,021,220 samples, 38.64%)</title><rect x=3D"440.3" y=3D"2053"=
 width=3D"456.0" height=3D"15.0" fill=3D"rgb(242,107,34)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"443.33" y=3D"2063.5" >__GI___ioctl</text>=0A</g>=0A<g >=
=0A<title>__x64_sys_ioctl (182,037,942 samples, 0.05%)</title><rect x=3D"12=
.7" y=3D"309" width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,226,18)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<t=
itle>shmem_fault (1,112,111,832 samples, 0.30%)</title><rect x=3D"168.5" y=
=3D"1717" width=3D"3.6" height=3D"15.0" fill=3D"rgb(213,131,19)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"171.53" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__count_memcg_events (314,229,400 samples, 0.08%)</title><rect x=3D"799.=
0" y=3D"1829" width=3D"1.0" height=3D"15.0" fill=3D"rgb(205,42,12)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"802.01" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<=
title>_raw_spin_unlock_irqrestore (66,489,269 samples, 0.02%)</title><rect =
x=3D"226.3" y=3D"1925" width=3D"0.2" height=3D"15.0" fill=3D"rgb(222,213,51=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"229.30" y=3D"1935.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_vcpu_load_vmcs (402,390,541 samples, 0.11%)</title><re=
ct x=3D"26.5" y=3D"53" width=3D"1.3" height=3D"15.0" fill=3D"rgb(217,198,4)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.49" y=3D"63.5" ></text>=0A</g>=0A<g=
 >=0A<title>__get_user_pages (790,301,371 samples, 0.21%)</title><rect x=3D=
"26.5" y=3D"261" width=3D"2.5" height=3D"15.0" fill=3D"rgb(215,138,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"271.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_faultin_pfn (1,140,093,687 samples, 0.31%)</title><rect x=3D"=
109.0" y=3D"1717" width=3D"3.7" height=3D"15.0" fill=3D"rgb(208,119,48)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"112.02" y=3D"1727.5" ></text>=0A</g>=0A<g =
>=0A<title>filemap_free_folio (66,393,799 samples, 0.02%)</title><rect x=3D=
"1178.6" y=3D"1829" width=3D"0.2" height=3D"15.0" fill=3D"rgb(224,133,54)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.57" y=3D"1839.5" ></text>=0A</g>=0A=
<g >=0A<title>__handle_mm_fault (61,757,117 samples, 0.02%)</title><rect x=
=3D"29.0" y=3D"245" width=3D"0.2" height=3D"15.0" fill=3D"rgb(251,218,16)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"255.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (380,476,439 samples, 0.10%)</title><rect x=3D"=
29.7" y=3D"1285" width=3D"1.2" height=3D"15.0" fill=3D"rgb(250,116,30)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"32.67" y=3D"1295.5" ></text>=0A</g>=0A<g >=
=0A<title>free_pcppages_bulk (198,724,816 samples, 0.05%)</title><rect x=3D=
"1176.5" y=3D"1797" width=3D"0.6" height=3D"15.0" fill=3D"rgb(214,191,50)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1179.47" y=3D"1807.5" ></text>=0A</g>=0A=
<g >=0A<title>__schedule (147,308,806 samples, 0.04%)</title><rect x=3D"24.=
7" y=3D"69" width=3D"0.5" height=3D"15.0" fill=3D"rgb(207,27,47)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"27.71" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title=
>native_read_msr (126,923,902 samples, 0.03%)</title><rect x=3D"35.8" y=3D"=
1253" width=3D"0.4" height=3D"15.0" fill=3D"rgb(206,78,11)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"38.82" y=3D"1263.5" ></text>=0A</g>=0A<g >=0A<title>__G=
I___ioctl (911,547,376 samples, 0.25%)</title><rect x=3D"29.2" y=3D"1653" w=
idth=3D"2.9" height=3D"15.0" fill=3D"rgb(234,223,25)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"32.24" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>finish_t=
ask_switch (159,748,140 samples, 0.04%)</title><rect x=3D"146.3" y=3D"1589"=
 width=3D"0.5" height=3D"15.0" fill=3D"rgb(236,210,50)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"149.28" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>__GI__=
_ioctl (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"245" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(238,181,47)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"15.08" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl=
 (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" y=3D"389" width=3D"0.=
9" height=3D"15.0" fill=3D"rgb(209,116,41)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"28.64" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unloc=
ked (2,459,896,715 samples, 0.66%)</title><rect x=3D"148.5" y=3D"1781" widt=
h=3D"7.8" height=3D"15.0" fill=3D"rgb(226,158,33)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"151.45" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm=
_fault (1,373,790,402 samples, 0.37%)</title><rect x=3D"74.3" y=3D"1541" wi=
dth=3D"4.4" height=3D"15.0" fill=3D"rgb(235,167,8)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"77.30" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_=
pages (1,060,421,518 samples, 0.29%)</title><rect x=3D"33.0" y=3D"1461" wid=
th=3D"3.4" height=3D"15.0" fill=3D"rgb(242,101,8)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"35.98" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCAL=
L_64 (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"469" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(237,45,15)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"32.00" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault=
 (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"165" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(218,140,9)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"15.50" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_=
run (1,850,870,166 samples, 0.50%)</title><rect x=3D"184.1" y=3D"1957" widt=
h=3D"5.9" height=3D"15.0" fill=3D"rgb(215,39,27)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"187.13" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>update_curr =
(1,489,600,080 samples, 0.40%)</title><rect x=3D"749.1" y=3D"1653" width=3D=
"4.7" height=3D"15.0" fill=3D"rgb(243,79,32)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"752.07" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock=
 (628,142,401 samples, 0.17%)</title><rect x=3D"143.7" y=3D"1589" width=3D"=
2.0" height=3D"15.0" fill=3D"rgb(228,112,2)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"146.71" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (948,421=
,280 samples, 0.26%)</title><rect x=3D"81.1" y=3D"1541" width=3D"3.0" heigh=
t=3D"15.0" fill=3D"rgb(206,189,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.0=
8" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (269,433,9=
71 samples, 0.07%)</title><rect x=3D"262.3" y=3D"1877" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(242,83,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31=
" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (700,745,341=
 samples, 0.19%)</title><rect x=3D"29.3" y=3D"1493" width=3D"2.2" height=3D=
"15.0" fill=3D"rgb(206,133,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.31" y=
=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (61,757,117 sam=
ples, 0.02%)</title><rect x=3D"29.0" y=3D"373" width=3D"0.2" height=3D"15.0=
" fill=3D"rgb(240,107,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"3=
83.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,088,324,720 sample=
s, 0.29%)</title><rect x=3D"84.5" y=3D"1701" width=3D"3.5" height=3D"15.0" =
fill=3D"rgb(246,210,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"171=
1.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (182,037,942 samples, =
0.05%)</title><rect x=3D"12.7" y=3D"197" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(253,33,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"207.5" >=
</text>=0A</g>=0A<g >=0A<title>do_syscall_64 (85,604,046,810 samples, 23.11=
%)</title><rect x=3D"899.6" y=3D"2021" width=3D"272.8" height=3D"15.0" fill=
=3D"rgb(227,222,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"902.64" y=3D"2031.5=
" >do_syscall_64</text>=0A</g>=0A<g >=0A<title>do_syscall_64 (2,083,270,665=
 samples, 0.56%)</title><rect x=3D"172.4" y=3D"1989" width=3D"6.6" height=
=3D"15.0" fill=3D"rgb(219,203,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.4=
0" y=3D"1999.5" ></text>=0A</g>=0A<g >=0A<title>xas_load (523,232,818 sampl=
es, 0.14%)</title><rect x=3D"893.1" y=3D"1909" width=3D"1.7" height=3D"15.0=
" fill=3D"rgb(224,122,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"896.15" y=3D"1=
919.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (1,142,740,434 sa=
mples, 0.31%)</title><rect x=3D"109.0" y=3D"1733" width=3D"3.7" height=3D"1=
5.0" fill=3D"rgb(213,148,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.02" y=
=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (46,392,999 samp=
les, 0.01%)</title><rect x=3D"178.9" y=3D"1877" width=3D"0.1" height=3D"15.=
0" fill=3D"rgb(240,49,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"181.88" y=3D"=
1887.5" ></text>=0A</g>=0A<g >=0A<title>__perf_event_task_sched_in (194,252=
,933 samples, 0.05%)</title><rect x=3D"83.5" y=3D"1413" width=3D"0.6" heigh=
t=3D"15.0" fill=3D"rgb(207,18,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.48=
" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (6=
6,497,849 samples, 0.02%)</title><rect x=3D"1188.6" y=3D"1797" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(229,170,33)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1191.63" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>find_busiest_grou=
p (160,784,438 samples, 0.04%)</title><rect x=3D"28.1" y=3D"53" width=3D"0.=
6" height=3D"15.0" fill=3D"rgb(246,210,33)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"31.14" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,=
099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1589" width=3D"19.2" heigh=
t=3D"15.0" fill=3D"rgb(246,75,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 sam=
ples, 1.63%)</title><rect x=3D"10.0" y=3D"581" width=3D"19.2" height=3D"15.=
0" fill=3D"rgb(226,201,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"=
591.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,026,979,445 samples, 0.2=
8%)</title><rect x=3D"84.6" y=3D"1557" width=3D"3.3" height=3D"15.0" fill=
=3D"rgb(221,72,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1567.5" =
></text>=0A</g>=0A<g >=0A<title>dequeue_entity (127,701,667 samples, 0.03%)=
</title><rect x=3D"53.2" y=3D"1333" width=3D"0.4" height=3D"15.0" fill=3D"r=
gb(237,152,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"56.16" y=3D"1343.5" ></t=
ext>=0A</g>=0A<g >=0A<title>do_syscall_64 (1,111,133,729 samples, 0.30%)</t=
itle><rect x=3D"13.3" y=3D"357" width=3D"3.5" height=3D"15.0" fill=3D"rgb(2=
53,13,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"367.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (221,624,162 samples, 0.06%)</title><=
rect x=3D"438.1" y=3D"2005" width=3D"0.7" height=3D"15.0" fill=3D"rgb(247,1=
17,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.14" y=3D"2015.5" ></text>=0A=
</g>=0A<g >=0A<title>shmem_get_folio_gfp (264,013,792 samples, 0.07%)</titl=
e><rect x=3D"25.6" y=3D"149" width=3D"0.9" height=3D"15.0" fill=3D"rgb(253,=
175,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=3D"159.5" ></text>=0A<=
/g>=0A<g >=0A<title>update_process_times (155,132,426 samples, 0.04%)</titl=
e><rect x=3D"903.4" y=3D"1829" width=3D"0.5" height=3D"15.0" fill=3D"rgb(21=
1,198,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.40" y=3D"1839.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (299,495,264 samples, 0.08%)</titl=
e><rect x=3D"743.7" y=3D"1669" width=3D"1.0" height=3D"15.0" fill=3D"rgb(21=
2,171,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"746.73" y=3D"1679.5" ></text>=
=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (219,093,086 sample=
s, 0.06%)</title><rect x=3D"782.0" y=3D"1685" width=3D"0.7" height=3D"15.0"=
 fill=3D"rgb(216,217,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"784.97" y=3D"1=
695.5" ></text>=0A</g>=0A<g >=0A<title>add_atomic_switch_msr.constprop.115 =
(46,556,455 samples, 0.01%)</title><rect x=3D"871.0" y=3D"1925" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(242,39,53)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"874.05" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>vmx_prepare_switch=
_to_guest (765,297,897 samples, 0.21%)</title><rect x=3D"832.4" y=3D"1941" =
width=3D"2.4" height=3D"15.0" fill=3D"rgb(247,209,53)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"835.40" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__sysve=
c_apic_timer_interrupt (160,833,494 samples, 0.04%)</title><rect x=3D"834.2=
" y=3D"1877" width=3D"0.5" height=3D"15.0" fill=3D"rgb(212,201,28)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<=
title>do_fault (1,049,973,543 samples, 0.28%)</title><rect x=3D"50.4" y=3D"=
1461" width=3D"3.3" height=3D"15.0" fill=3D"rgb(236,37,1)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"53.40" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__GI=
___ioctl (123,122,609 samples, 0.03%)</title><rect x=3D"11.4" y=3D"213" wid=
th=3D"0.4" height=3D"15.0" fill=3D"rgb(244,41,41)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"14.37" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,=
040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"597" width=3D"19.2=
" height=3D"15.0" fill=3D"rgb(254,74,32)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>schedule (264,013,79=
2 samples, 0.07%)</title><rect x=3D"25.6" y=3D"117" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(211,38,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=
=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (470,606,309 s=
amples, 0.13%)</title><rect x=3D"704.7" y=3D"1701" width=3D"1.5" height=3D"=
15.0" fill=3D"rgb(215,155,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.72" y=
=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (2,913,335,273 sa=
mples, 0.79%)</title><rect x=3D"158.2" y=3D"1957" width=3D"9.3" height=3D"1=
5.0" fill=3D"rgb(228,35,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"161.22" y=
=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>demand_paging_t (370,392,771,58=
4 samples, 100.00%)</title><rect x=3D"10.0" y=3D"2069" width=3D"1180.0" hei=
ght=3D"15.0" fill=3D"rgb(252,89,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.=
00" y=3D"2079.5" >demand_paging_t</text>=0A</g>=0A<g >=0A<title>__x64_sys_i=
octl (2,549,679,159 samples, 0.69%)</title><rect x=3D"59.8" y=3D"1701" widt=
h=3D"8.1" height=3D"15.0" fill=3D"rgb(241,107,22)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"62.80" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl=
 (1,713,792,504 samples, 0.46%)</title><rect x=3D"32.1" y=3D"1669" width=3D=
"5.5" height=3D"15.0" fill=3D"rgb(220,168,20)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"35.15" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>psi_account_irqt=
ime (155,749,882 samples, 0.04%)</title><rect x=3D"166.2" y=3D"1605" width=
=3D"0.5" height=3D"15.0" fill=3D"rgb(214,108,45)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"169.16" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (=
2,131,350,080 samples, 0.58%)</title><rect x=3D"112.9" y=3D"1621" width=3D"=
6.7" height=3D"15.0" fill=3D"rgb(238,55,34)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"115.86" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>task_work_run (88=
,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"1973" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(227,151,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"900.12" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>schedule (539,769,982=
 samples, 0.15%)</title><rect x=3D"104.9" y=3D"1525" width=3D"1.7" height=
=3D"15.0" fill=3D"rgb(244,81,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"107.88=
" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (2,131,3=
50,080 samples, 0.58%)</title><rect x=3D"112.9" y=3D"1589" width=3D"6.7" he=
ight=3D"15.0" fill=3D"rgb(247,131,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
15.86" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (6,742=
,648,185 samples, 1.82%)</title><rect x=3D"227.1" y=3D"1941" width=3D"21.5"=
 height=3D"15.0" fill=3D"rgb(222,210,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"230.08" y=3D"1951.5" >d..</text>=0A</g>=0A<g >=0A<title>__schedule (405=
,009,126 samples, 0.11%)</title><rect x=3D"170.8" y=3D"1653" width=3D"1.3" =
height=3D"15.0" fill=3D"rgb(252,202,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
173.79" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (2,06=
3,122,219 samples, 0.56%)</title><rect x=3D"74.1" y=3D"1765" width=3D"6.5" =
height=3D"15.0" fill=3D"rgb(205,210,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
77.08" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>follow_page_pte (280,95=
9,086 samples, 0.08%)</title><rect x=3D"159.4" y=3D"1765" width=3D"0.9" hei=
ght=3D"15.0" fill=3D"rgb(228,105,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16=
2.37" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run =
(98,073,756 samples, 0.03%)</title><rect x=3D"11.8" y=3D"149" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(242,49,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"14.76" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (133=
,987,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"261" width=3D"0.4" he=
ight=3D"15.0" fill=3D"rgb(221,40,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19=
.81" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,697,7=
71,549 samples, 0.46%)</title><rect x=3D"173.4" y=3D"1781" width=3D"5.4" he=
ight=3D"15.0" fill=3D"rgb(253,53,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"17=
6.38" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_in=
terrupt (221,623,213 samples, 0.06%)</title><rect x=3D"903.3" y=3D"1941" wi=
dth=3D"0.7" height=3D"15.0" fill=3D"rgb(219,214,11)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"906.26" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>do_vmi_=
munmap (1,619,511,008 samples, 0.44%)</title><rect x=3D"1183.8" y=3D"1957" =
width=3D"5.1" height=3D"15.0" fill=3D"rgb(246,95,6)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1186.76" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>asm_sy=
svec_apic_timer_interrupt (221,644,971 samples, 0.06%)</title><rect x=3D"27=
3.8" y=3D"1925" width=3D"0.7" height=3D"15.0" fill=3D"rgb(206,79,40)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"276.77" y=3D"1935.5" ></text>=0A</g>=0A<g >=
=0A<title>update_cfs_group (35,523,952 samples, 0.01%)</title><rect x=3D"74=
9.0" y=3D"1653" width=3D"0.1" height=3D"15.0" fill=3D"rgb(213,50,46)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"751.95" y=3D"1663.5" ></text>=0A</g>=0A<g >=
=0A<title>hva_to_pfn (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=
=3D"69" width=3D"0.3" height=3D"15.0" fill=3D"rgb(227,61,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"15.08" y=3D"79.5" ></text>=0A</g>=0A<g >=0A<title>h=
rtimer_interrupt (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D=
"1477" width=3D"0.6" height=3D"15.0" fill=3D"rgb(219,84,54)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"114.26" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>[=
kvm-intel.ko] (42,089,385 samples, 0.01%)</title><rect x=3D"128.0" y=3D"178=
1" width=3D"0.1" height=3D"15.0" fill=3D"rgb(206,181,23)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"130.99" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>do_r=
aw_spin_unlock (66,494,314 samples, 0.02%)</title><rect x=3D"248.7" y=3D"19=
41" width=3D"0.2" height=3D"15.0" fill=3D"rgb(247,2,10)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"251.73" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_=
enter_guest (1,356,735,820 samples, 0.37%)</title><rect x=3D"128.2" y=3D"18=
29" width=3D"4.3" height=3D"15.0" fill=3D"rgb(222,16,14)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"131.19" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>sche=
dule (405,009,126 samples, 0.11%)</title><rect x=3D"170.8" y=3D"1669" width=
=3D"1.3" height=3D"15.0" fill=3D"rgb(217,130,28)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"173.79" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCAL=
L_64 (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"373" width=
=3D"3.5" height=3D"15.0" fill=3D"rgb(217,52,36)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"16.27" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>__vmx_complete_=
interrupts (34,801,774 samples, 0.01%)</title><rect x=3D"870.7" y=3D"1925" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(253,8,15)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"873.71" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>handle_=
userfault (1,126,406,901 samples, 0.30%)</title><rect x=3D"88.7" y=3D"1509"=
 width=3D"3.6" height=3D"15.0" fill=3D"rgb(239,109,20)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"91.71" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>mmu_top=
up_memory_caches (47,709,271 samples, 0.01%)</title><rect x=3D"11.6" y=3D"5=
3" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,228,20)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"14.61" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>get_use=
r_pages_unlocked (1,407,651,928 samples, 0.38%)</title><rect x=3D"74.2" y=
=3D"1589" width=3D"4.5" height=3D"15.0" fill=3D"rgb(227,152,25)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"77.19" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<titl=
e>tick_sched_handle.isra.21 (80,050,831 samples, 0.02%)</title><rect x=3D"7=
59.7" y=3D"1573" width=3D"0.3" height=3D"15.0" fill=3D"rgb(218,217,20)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"762.74" y=3D"1583.5" ></text>=0A</g>=0A<g =
>=0A<title>__get_user_pages (2,288,045,108 samples, 0.62%)</title><rect x=
=3D"159.4" y=3D"1781" width=3D"7.3" height=3D"15.0" fill=3D"rgb(254,39,26)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"162.37" y=3D"1791.5" ></text>=0A</g>=0A=
<g >=0A<title>__x64_sys_ioctl (98,073,756 samples, 0.03%)</title><rect x=3D=
"11.8" y=3D"181" width=3D"0.3" height=3D"15.0" fill=3D"rgb(237,65,1)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"14.76" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<=
title>[unknown] (4,909,419,389 samples, 1.33%)</title><rect x=3D"10.0" y=3D=
"453" width=3D"15.6" height=3D"15.0" fill=3D"rgb(247,224,15)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>=
do_raw_spin_lock (40,943,540 samples, 0.01%)</title><rect x=3D"164.8" y=3D"=
1653" width=3D"0.1" height=3D"15.0" fill=3D"rgb(222,170,10)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"167.80" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>h=
andle_userfault (85,315,102,989 samples, 23.03%)</title><rect x=3D"511.6" y=
=3D"1733" width=3D"271.8" height=3D"15.0" fill=3D"rgb(234,204,8)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"514.57" y=3D"1743.5" >handle_userfault</text>=0A<=
/g>=0A<g >=0A<title>restore_fpregs_from_fpstate (268,672,775 samples, 0.07%=
)</title><rect x=3D"458.9" y=3D"1925" width=3D"0.9" height=3D"15.0" fill=3D=
"rgb(205,175,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"461.92" y=3D"1935.5" >=
</text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,049,973,543 samples, =
0.28%)</title><rect x=3D"50.4" y=3D"1413" width=3D"3.3" height=3D"15.0" fil=
l=3D"rgb(250,198,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.40" y=3D"1423.5=
" ></text>=0A</g>=0A<g >=0A<title>[unknown] (38,456,652,103 samples, 10.38%=
)</title><rect x=3D"10.0" y=3D"1941" width=3D"122.5" height=3D"15.0" fill=
=3D"rgb(249,226,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1951.5"=
 >[unknown]</text>=0A</g>=0A<g >=0A<title>workingset_age_nonresident (1,460=
,184,491 samples, 0.39%)</title><rect x=3D"803.7" y=3D"1845" width=3D"4.7" =
height=3D"15.0" fill=3D"rgb(218,155,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
806.71" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,17=
7,405,536 samples, 0.32%)</title><rect x=3D"74.9" y=3D"1461" width=3D"3.8" =
height=3D"15.0" fill=3D"rgb(224,179,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"77.92" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_write_lock (110=
,803,799 samples, 0.03%)</title><rect x=3D"1170.9" y=3D"1813" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(208,33,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1173.87" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>down_read (336,588,0=
08 samples, 0.09%)</title><rect x=3D"882.4" y=3D"1957" width=3D"1.1" height=
=3D"15.0" fill=3D"rgb(238,1,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"885.45" =
y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (1,381,981=
,405 samples, 0.37%)</title><rect x=3D"93.9" y=3D"1541" width=3D"4.4" heigh=
t=3D"15.0" fill=3D"rgb(221,1,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.91"=
 y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_notifier_invalidate_r=
ange_start (41,394,896 samples, 0.01%)</title><rect x=3D"875.4" y=3D"1861" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(249,98,5)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"878.39" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>shmem_g=
et_folio_gfp (1,012,875,001 samples, 0.27%)</title><rect x=3D"33.1" y=3D"13=
65" width=3D"3.3" height=3D"15.0" fill=3D"rgb(215,146,47)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"36.13" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>avai=
lable_idle_cpu (288,172,036 samples, 0.08%)</title><rect x=3D"218.5" y=3D"1=
861" width=3D"0.9" height=3D"15.0" fill=3D"rgb(209,77,16)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"221.47" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__h=
andle_mm_fault (182,037,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"11=
7" width=3D"0.6" height=3D"15.0" fill=3D"rgb(217,96,6)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"15.69" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spi=
n_unlock_irqrestore (91,216,121 samples, 0.02%)</title><rect x=3D"704.4" y=
=3D"1701" width=3D"0.3" height=3D"15.0" fill=3D"rgb(246,203,50)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"707.43" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<tit=
le>psi_account_irqtime (152,531,113 samples, 0.04%)</title><rect x=3D"106.1=
" y=3D"1477" width=3D"0.5" height=3D"15.0" fill=3D"rgb(249,209,15)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"109.12" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<=
title>syscall_exit_to_user_mode_prepare (266,298,763 samples, 0.07%)</title=
><rect x=3D"1171.3" y=3D"1989" width=3D"0.8" height=3D"15.0" fill=3D"rgb(22=
2,129,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1174.30" y=3D"1999.5" ></text=
>=0A</g>=0A<g >=0A<title>switch_fpu_return (282,478,351 samples, 0.08%)</ti=
tle><rect x=3D"458.9" y=3D"1941" width=3D"0.9" height=3D"15.0" fill=3D"rgb(=
212,81,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"461.87" y=3D"1951.5" ></text=
>=0A</g>=0A<g >=0A<title>schedule (208,622,550 samples, 0.06%)</title><rect=
 x=3D"35.7" y=3D"1333" width=3D"0.7" height=3D"15.0" fill=3D"rgb(246,112,37=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"38.69" y=3D"1343.5" ></text>=0A</g>=
=0A<g >=0A<title>pick_next_task_idle (85,040,880 samples, 0.02%)</title><re=
ct x=3D"770.3" y=3D"1685" width=3D"0.3" height=3D"15.0" fill=3D"rgb(228,13,=
14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"773.31" y=3D"1695.5" ></text>=0A</g=
>=0A<g >=0A<title>__get_user_pages (1,111,133,729 samples, 0.30%)</title><r=
ect x=3D"13.3" y=3D"181" width=3D"3.5" height=3D"15.0" fill=3D"rgb(250,5,38=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"191.5" ></text>=0A</g>=0A=
<g >=0A<title>__get_user_pages (1,209,096,599 samples, 0.33%)</title><rect =
x=3D"55.0" y=3D"1525" width=3D"3.8" height=3D"15.0" fill=3D"rgb(254,92,36)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.96" y=3D"1535.5" ></text>=0A</g>=0A<=
g >=0A<title>kvm_faultin_pfn (1,088,324,720 samples, 0.29%)</title><rect x=
=3D"84.5" y=3D"1653" width=3D"3.5" height=3D"15.0" fill=3D"rgb(253,16,53)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"1663.5" ></text>=0A</g>=0A<g=
 >=0A<title>vmx_vcpu_pi_load (140,780,126 samples, 0.04%)</title><rect x=3D=
"146.3" y=3D"1541" width=3D"0.5" height=3D"15.0" fill=3D"rgb(240,197,25)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"149.34" y=3D"1551.5" ></text>=0A</g>=0A<g=
 >=0A<title>_find_next_and_bit (54,093,156 samples, 0.01%)</title><rect x=
=3D"29.0" y=3D"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb(223,4,22)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"32.02" y=3D"47.5" ></text>=0A</g>=0A<g >=
=0A<title>shmem_get_folio_gfp (2,423,604,255 samples, 0.65%)</title><rect x=
=3D"132.6" y=3D"1637" width=3D"7.7" height=3D"15.0" fill=3D"rgb(236,116,51)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.59" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"1637" width=3D"19.2" height=3D"15.0" fill=3D"rgb(206,45,5)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1647.5" ></text>=0A</g>=0A<g >=
=0A<title>native_queued_spin_lock_slowpath (528,453,476 samples, 0.14%)</ti=
tle><rect x=3D"169.1" y=3D"1621" width=3D"1.6" height=3D"15.0" fill=3D"rgb(=
232,202,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"172.05" y=3D"1631.5" ></tex=
t>=0A</g>=0A<g >=0A<title>__mmu_notifier_invalidate_range_start (132,959,37=
6 samples, 0.04%)</title><rect x=3D"1170.9" y=3D"1909" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(218,38,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87=
" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq (21=
4,920,756 samples, 0.06%)</title><rect x=3D"25.6" y=3D"37" width=3D"0.7" he=
ight=3D"15.0" fill=3D"rgb(224,196,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"2=
8.64" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>folio_activate_fn (309,327=
,693 samples, 0.08%)</title><rect x=3D"156.3" y=3D"1749" width=3D"1.0" heig=
ht=3D"15.0" fill=3D"rgb(207,72,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"159.=
29" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (1=
,167,137,370 samples, 0.32%)</title><rect x=3D"80.8" y=3D"1717" width=3D"3.=
7" height=3D"15.0" fill=3D"rgb(213,148,43)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"83.75" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>__kvm_migrate_apic_=
timer (34,977,727 samples, 0.01%)</title><rect x=3D"454.2" y=3D"1925" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(217,153,23)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"457.20" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcp=
u_ioctl_run (2,083,270,665 samples, 0.56%)</title><rect x=3D"172.4" y=3D"19=
41" width=3D"6.6" height=3D"15.0" fill=3D"rgb(211,115,32)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"175.40" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>tdp=
_iter_next (373,572,219 samples, 0.10%)</title><rect x=3D"816.3" y=3D"1877"=
 width=3D"1.2" height=3D"15.0" fill=3D"rgb(206,74,25)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"819.32" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu=
_page_fault (1,604,157,291 samples, 0.43%)</title><rect x=3D"93.4" y=3D"171=
7" width=3D"5.1" height=3D"15.0" fill=3D"rgb(227,36,14)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"96.39" y=3D"1727.5" ></text>=0A</g>=0A<g >=0A<title>vmx_pa=
ssthrough_lbr_msrs (152,049,187 samples, 0.04%)</title><rect x=3D"874.9" y=
=3D"1925" width=3D"0.5" height=3D"15.0" fill=3D"rgb(243,35,9)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"877.89" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_vcpu_ioctl (2,179,708,244 samples, 0.59%)</title><rect x=3D"121.2" y=
=3D"1845" width=3D"7.0" height=3D"15.0" fill=3D"rgb(225,110,32)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"124.25" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<tit=
le>shmem_get_folio_gfp (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" =
y=3D"181" width=3D"0.2" height=3D"15.0" fill=3D"rgb(221,108,5)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"32.00" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>=
rcu_note_context_switch (202,864,145 samples, 0.05%)</title><rect x=3D"157.=
5" y=3D"1829" width=3D"0.7" height=3D"15.0" fill=3D"rgb(211,224,5)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"160.51" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<=
title>find_extend_vma (117,015,914 samples, 0.03%)</title><rect x=3D"37.7" =
y=3D"1461" width=3D"0.4" height=3D"15.0" fill=3D"rgb(218,198,7)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"40.74" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__x64_sys_ioctl (2,063,122,219 samples, 0.56%)</title><rect x=3D"74.1" y=
=3D"1733" width=3D"6.5" height=3D"15.0" fill=3D"rgb(245,20,29)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"77.08" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title=
>free_unref_page_commit (44,167,347 samples, 0.01%)</title><rect x=3D"1177.=
1" y=3D"1797" width=3D"0.1" height=3D"15.0" fill=3D"rgb(221,208,54)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1180.10" y=3D"1807.5" ></text>=0A</g>=0A<g >=
=0A<title>native_queued_spin_lock_slowpath (669,618,700 samples, 0.18%)</ti=
tle><rect x=3D"81.3" y=3D"1413" width=3D"2.1" height=3D"15.0" fill=3D"rgb(2=
38,145,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"84.29" y=3D"1423.5" ></text>=
=0A</g>=0A<g >=0A<title>pmd_none_or_trans_huge_or_clear_bad (64,777,162 sam=
ples, 0.02%)</title><rect x=3D"783.6" y=3D"1797" width=3D"0.2" height=3D"15=
.0" fill=3D"rgb(213,33,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"786.58" y=3D"=
1807.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (66,476,0=
49 samples, 0.02%)</title><rect x=3D"219.4" y=3D"1861" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(217,171,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"222.3=
9" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>kvm_set_user_return_msr (19=
2,673,968 samples, 0.05%)</title><rect x=3D"834.1" y=3D"1925" width=3D"0.6"=
 height=3D"15.0" fill=3D"rgb(235,22,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"837.08" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,02=
6,979,445 samples, 0.28%)</title><rect x=3D"84.6" y=3D"1589" width=3D"3.3" =
height=3D"15.0" fill=3D"rgb(230,130,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"87.63" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (1,07=
2,556,023 samples, 0.29%)</title><rect x=3D"109.2" y=3D"1557" width=3D"3.4"=
 height=3D"15.0" fill=3D"rgb(231,209,41)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"112.19" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (=
1,286,797,459 samples, 0.35%)</title><rect x=3D"100.6" y=3D"1493" width=3D"=
4.1" height=3D"15.0" fill=3D"rgb(207,227,43)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"103.63" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<title>record_times (80=
,380,957 samples, 0.02%)</title><rect x=3D"780.6" y=3D"1653" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(246,182,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"783.59" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,3=
26,971,558 samples, 0.36%)</title><rect x=3D"108.6" y=3D"1781" width=3D"4.2=
" height=3D"15.0" fill=3D"rgb(226,207,5)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"111.62" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (3=
,348,716,533 samples, 0.90%)</title><rect x=3D"147.5" y=3D"1925" width=3D"1=
0.7" height=3D"15.0" fill=3D"rgb(253,224,20)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"150.55" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg =
(354,960,434 samples, 0.10%)</title><rect x=3D"170.8" y=3D"1605" width=3D"1=
.1" height=3D"15.0" fill=3D"rgb(215,57,38)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"173.79" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>__x86_indirect_thu=
nk_array (66,391,278 samples, 0.02%)</title><rect x=3D"897.9" y=3D"2037" wi=
dth=3D"0.3" height=3D"15.0" fill=3D"rgb(205,219,2)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"900.94" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<title>kvm_releas=
e_pfn_clean (47,964,076 samples, 0.01%)</title><rect x=3D"73.7" y=3D"1605" =
width=3D"0.1" height=3D"15.0" fill=3D"rgb(223,12,50)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"76.68" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>userfaul=
tfd_ioctl (19,425,165,142 samples, 5.24%)</title><rect x=3D"190.0" y=3D"197=
3" width=3D"61.9" height=3D"15.0" fill=3D"rgb(210,82,35)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"193.03" y=3D"1983.5" >userfa..</text>=0A</g>=0A<g >=0A<ti=
tle>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"7=
73" width=3D"19.2" height=3D"15.0" fill=3D"rgb(214,226,21)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"13.00" y=3D"783.5" ></text>=0A</g>=0A<g >=0A<title>kvm_=
vcpu_ioctl (1,143,809,245 samples, 0.31%)</title><rect x=3D"84.5" y=3D"1749=
" width=3D"3.7" height=3D"15.0" fill=3D"rgb(226,84,40)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"87.52" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_=
spin_lock (2,344,242,284 samples, 0.63%)</title><rect x=3D"17.2" y=3D"53" w=
idth=3D"7.5" height=3D"15.0" fill=3D"rgb(228,90,40)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"20.24" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSC=
ALL_64 (911,547,376 samples, 0.25%)</title><rect x=3D"29.2" y=3D"1637" widt=
h=3D"2.9" height=3D"15.0" fill=3D"rgb(210,16,0)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"32.24" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (=
133,987,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"405" width=3D"0.4"=
 height=3D"15.0" fill=3D"rgb(245,73,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
19.81" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (80,05=
0,831 samples, 0.02%)</title><rect x=3D"759.7" y=3D"1621" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(219,63,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"762=
.74" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>file_has_perm (115,372,28=
4 samples, 0.03%)</title><rect x=3D"265.0" y=3D"1941" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(244,99,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"268.02=
" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,0=
80,385,713 samples, 0.29%)</title><rect x=3D"33.0" y=3D"1477" width=3D"3.4"=
 height=3D"15.0" fill=3D"rgb(236,7,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
35.98" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,036,552,52=
0 samples, 1.63%)</title><rect x=3D"10.0" y=3D"533" width=3D"19.2" height=
=3D"15.0" fill=3D"rgb(210,120,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00=
" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>queued_read_lock_slowpath (17=
5,944,891 samples, 0.05%)</title><rect x=3D"130.9" y=3D"1765" width=3D"0.6"=
 height=3D"15.0" fill=3D"rgb(245,8,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
133.95" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (252,519,053=
 samples, 0.07%)</title><rect x=3D"10.0" y=3D"181" width=3D"0.8" height=3D"=
15.0" fill=3D"rgb(224,145,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>folio_mark_accessed (44,328,904 =
samples, 0.01%)</title><rect x=3D"1185.4" y=3D"1877" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(215,148,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1188.=
45" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (652,061,555 sam=
ples, 0.18%)</title><rect x=3D"10.0" y=3D"245" width=3D"2.1" height=3D"15.0=
" fill=3D"rgb(209,200,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"2=
55.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (1,132,255,149 sampl=
es, 0.31%)</title><rect x=3D"168.5" y=3D"1797" width=3D"3.6" height=3D"15.0=
" fill=3D"rgb(251,14,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.47" y=3D"18=
07.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (2,007,086,022 sa=
mples, 0.54%)</title><rect x=3D"160.3" y=3D"1685" width=3D"6.4" height=3D"1=
5.0" fill=3D"rgb(252,91,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=
=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock (369,403,167 sam=
ples, 0.10%)</title><rect x=3D"885.6" y=3D"1941" width=3D"1.1" height=3D"15=
.0" fill=3D"rgb(233,96,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"888.57" y=3D=
"1951.5" ></text>=0A</g>=0A<g >=0A<title>vmx_interrupt_blocked (93,966,367 =
samples, 0.03%)</title><rect x=3D"794.2" y=3D"1845" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(238,189,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"797.24" =
y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_read_unlock (518,952,22=
1 samples, 0.14%)</title><rect x=3D"463.1" y=3D"1877" width=3D"1.6" height=
=3D"15.0" fill=3D"rgb(241,89,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"466.05=
" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (133,987,142=
 samples, 0.04%)</title><rect x=3D"16.8" y=3D"245" width=3D"0.4" height=3D"=
15.0" fill=3D"rgb(229,126,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=
=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>llist_add_batch (155,140,884 sam=
ples, 0.04%)</title><rect x=3D"222.6" y=3D"1845" width=3D"0.5" height=3D"15=
.0" fill=3D"rgb(244,91,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"225.56" y=3D=
"1855.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (2,007,086,022 samples,=
 0.54%)</title><rect x=3D"160.3" y=3D"1717" width=3D"6.4" height=3D"15.0" f=
ill=3D"rgb(223,163,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=3D"172=
7.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (123,051,561 samples, =
0.03%)</title><rect x=3D"10.0" y=3D"85" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(252,225,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"95.5" >=
</text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (295,823,689 samples,=
 0.08%)</title><rect x=3D"84.6" y=3D"1461" width=3D"1.0" height=3D"15.0" fi=
ll=3D"rgb(224,225,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1471.5=
" ></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (160,833,4=
94 samples, 0.04%)</title><rect x=3D"834.2" y=3D"1749" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(224,127,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.1=
8" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,293,336,=
492 samples, 0.35%)</title><rect x=3D"185.8" y=3D"1813" width=3D"4.1" heigh=
t=3D"15.0" fill=3D"rgb(217,106,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.=
75" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,697,771,549 sa=
mples, 0.46%)</title><rect x=3D"173.4" y=3D"1765" width=3D"5.4" height=3D"1=
5.0" fill=3D"rgb(228,189,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.38" y=
=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (145,741,482 s=
amples, 0.04%)</title><rect x=3D"25.2" y=3D"341" width=3D"0.4" height=3D"15=
.0" fill=3D"rgb(232,161,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D=
"351.5" ></text>=0A</g>=0A<g >=0A<title>free_unref_page_list (441,745,278 s=
amples, 0.12%)</title><rect x=3D"1176.0" y=3D"1813" width=3D"1.4" height=3D=
"15.0" fill=3D"rgb(224,134,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1178.97"=
 y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>__vdso_clock_gettime (368,596=
,458 samples, 0.10%)</title><rect x=3D"434.5" y=3D"2005" width=3D"1.2" heig=
ht=3D"15.0" fill=3D"rgb(218,73,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"437.=
55" y=3D"2015.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common (312,099,=
913 samples, 0.08%)</title><rect x=3D"109.2" y=3D"1525" width=3D"1.0" heigh=
t=3D"15.0" fill=3D"rgb(244,104,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.=
19" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (15,400,871,677 =
samples, 4.16%)</title><rect x=3D"10.0" y=3D"1749" width=3D"49.1" height=3D=
"15.0" fill=3D"rgb(226,36,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"1759.5" >[unk..</text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (31,710,47=
5 samples, 0.01%)</title><rect x=3D"80.6" y=3D"1781" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(221,216,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.65"=
 y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (2,032,317=
,152 samples, 0.55%)</title><rect x=3D"172.4" y=3D"1877" width=3D"6.5" heig=
ht=3D"15.0" fill=3D"rgb(234,143,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175=
.40" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (159,314=
,940 samples, 0.04%)</title><rect x=3D"10.8" y=3D"85" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(242,85,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80"=
 y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>finish_task_switch (52,556,776 =
samples, 0.01%)</title><rect x=3D"58.2" y=3D"1365" width=3D"0.2" height=3D"=
15.0" fill=3D"rgb(229,203,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"61.19" y=
=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (144,115,557 sa=
mples, 0.04%)</title><rect x=3D"77.4" y=3D"1381" width=3D"0.5" height=3D"15=
.0" fill=3D"rgb(234,121,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80.44" y=3D=
"1391.5" ></text>=0A</g>=0A<g >=0A<title>do_vmi_align_munmap (1,619,511,008=
 samples, 0.44%)</title><rect x=3D"1183.8" y=3D"1941" width=3D"5.1" height=
=3D"15.0" fill=3D"rgb(254,30,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186.7=
6" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>filemap_unaccount_folio (39=
6,426,679 samples, 0.11%)</title><rect x=3D"1179.2" y=3D"1797" width=3D"1.3=
" height=3D"15.0" fill=3D"rgb(246,117,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1182.21" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_g=
fp (133,987,142 samples, 0.04%)</title><rect x=3D"16.8" y=3D"101" width=3D"=
0.4" height=3D"15.0" fill=3D"rgb(231,101,12)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"19.81" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (=
66,222,049 samples, 0.02%)</title><rect x=3D"1183.1" y=3D"1813" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(224,3,54)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1186.05" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (=
145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=3D"325" width=3D"0.4"=
 height=3D"15.0" fill=3D"rgb(227,21,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
28.18" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run =
(159,314,940 samples, 0.04%)</title><rect x=3D"10.8" y=3D"101" width=3D"0.5=
" height=3D"15.0" fill=3D"rgb(235,36,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.80" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>__inode_security_rev=
alidate (44,393,388 samples, 0.01%)</title><rect x=3D"875.9" y=3D"1957" wid=
th=3D"0.2" height=3D"15.0" fill=3D"rgb(222,29,21)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"878.95" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exi=
t_to_user_mode_prepare (44,336,313 samples, 0.01%)</title><rect x=3D"438.5"=
 y=3D"1973" width=3D"0.1" height=3D"15.0" fill=3D"rgb(254,117,51)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"441.49" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<t=
itle>pick_next_task_fair (51,506,394 samples, 0.01%)</title><rect x=3D"96.9=
" y=3D"1477" width=3D"0.1" height=3D"15.0" fill=3D"rgb(244,61,4)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"99.86" y=3D"1487.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__get_user_pages (686,648,674 samples, 0.19%)</title><rect x=3D"29.4" y=
=3D"1445" width=3D"2.1" height=3D"15.0" fill=3D"rgb(237,126,38)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"32.35" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<titl=
e>hva_to_pfn (61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"309" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(249,67,45)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"32.00" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>kvm_relea=
se_pfn_clean (75,413,338 samples, 0.02%)</title><rect x=3D"11.4" y=3D"53" w=
idth=3D"0.2" height=3D"15.0" fill=3D"rgb(244,224,52)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"14.37" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>up_read (6=
74,771,117 samples, 0.18%)</title><rect x=3D"791.4" y=3D"1861" width=3D"2.2=
" height=3D"15.0" fill=3D"rgb(222,59,27)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"794.43" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (790,30=
1,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"117" width=3D"2.5" heigh=
t=3D"15.0" fill=3D"rgb(221,89,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48=
" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title>add_wait_queue (2,146,924,615=
 samples, 0.58%)</title><rect x=3D"276.1" y=3D"1941" width=3D"6.8" height=
=3D"15.0" fill=3D"rgb(253,40,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"279.07=
" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (133=
,604,879,493 samples, 36.07%)</title><rect x=3D"449.9" y=3D"1973" width=3D"=
425.6" height=3D"15.0" fill=3D"rgb(246,91,43)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"452.89" y=3D"1983.5" >kvm_arch_vcpu_ioctl_run</text>=0A</g>=0A<g >=
=0A<title>kvm_unmap_gfn_range (88,418,539 samples, 0.02%)</title><rect x=3D=
"897.1" y=3D"1877" width=3D"0.3" height=3D"15.0" fill=3D"rgb(237,104,14)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"900.12" y=3D"1887.5" ></text>=0A</g>=0A<g=
 >=0A<title>preempt_count_add (34,274,216 samples, 0.01%)</title><rect x=3D=
"776.6" y=3D"1669" width=3D"0.1" height=3D"15.0" fill=3D"rgb(253,18,24)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"779.58" y=3D"1679.5" ></text>=0A</g>=0A<g =
>=0A<title>[kvm-intel.ko] (219,718,564 samples, 0.06%)</title><rect x=3D"49=
.1" y=3D"1573" width=3D"0.7" height=3D"15.0" fill=3D"rgb(214,7,19)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"52.05" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<t=
itle>kvm_mmu_page_fault (99,714,073 samples, 0.03%)</title><rect x=3D"12.1"=
 y=3D"117" width=3D"0.3" height=3D"15.0" fill=3D"rgb(213,14,45)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"15.08" y=3D"127.5" ></text>=0A</g>=0A<g >=0A<title=
>vmx_handle_exit (2,278,033,377 samples, 0.62%)</title><rect x=3D"99.5" y=
=3D"1749" width=3D"7.2" height=3D"15.0" fill=3D"rgb(224,36,3)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"102.47" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<titl=
e>shmem_get_folio_gfp (1,167,219,750 samples, 0.32%)</title><rect x=3D"55.1=
" y=3D"1429" width=3D"3.7" height=3D"15.0" fill=3D"rgb(243,71,36)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"58.10" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__get_user_pages (145,741,482 samples, 0.04%)</title><rect x=3D"25.2" y=
=3D"229" width=3D"0.4" height=3D"15.0" fill=3D"rgb(221,113,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"28.18" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>=
__cgroup_account_cputime (37,027,570 samples, 0.01%)</title><rect x=3D"751.=
1" y=3D"1637" width=3D"0.1" height=3D"15.0" fill=3D"rgb(254,65,19)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"754.10" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<=
title>all (370,392,771,584 samples, 100%)</title><rect x=3D"10.0" y=3D"2085=
" width=3D"1180.0" height=3D"15.0" fill=3D"rgb(221,182,23)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"13.00" y=3D"2095.5" ></text>=0A</g>=0A<g >=0A<title>vcp=
u_enter_guest (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"197"=
 width=3D"0.2" height=3D"15.0" fill=3D"rgb(246,113,25)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"15.50" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>__schedu=
le (50,279,799 samples, 0.01%)</title><rect x=3D"154.1" y=3D"1621" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(244,215,32)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"157.14" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>__fget_light (3=
10,310,264 samples, 0.08%)</title><rect x=3D"901.5" y=3D"1973" width=3D"1.0=
" height=3D"15.0" fill=3D"rgb(237,222,13)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"904.55" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_l=
ock (654,933,098 samples, 0.18%)</title><rect x=3D"50.5" y=3D"1381" width=
=3D"2.1" height=3D"15.0" fill=3D"rgb(212,180,9)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"53.53" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_=
timer_interrupt (219,093,086 samples, 0.06%)</title><rect x=3D"782.0" y=3D"=
1653" width=3D"0.7" height=3D"15.0" fill=3D"rgb(222,148,35)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"784.97" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>k=
vm_vcpu_ioctl (1,688,676,626 samples, 0.46%)</title><rect x=3D"32.2" y=3D"1=
605" width=3D"5.4" height=3D"15.0" fill=3D"rgb(254,84,1)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"35.23" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>raw_s=
pin_rq_lock_nested (109,239,051 samples, 0.03%)</title><rect x=3D"28.7" y=
=3D"53" width=3D"0.3" height=3D"15.0" fill=3D"rgb(210,30,16)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"31.65" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>_=
_dentry_kill (3,024,182,225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"=
1925" width=3D"9.7" height=3D"15.0" fill=3D"rgb(247,187,39)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1177.12" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>=
queued_read_lock_slowpath (3,953,861,276 samples, 1.07%)</title><rect x=3D"=
817.6" y=3D"1893" width=3D"12.6" height=3D"15.0" fill=3D"rgb(232,159,36)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"820.64" y=3D"1903.5" ></text>=0A</g>=0A<g=
 >=0A<title>__get_user_pages (1,417,336,558 samples, 0.38%)</title><rect x=
=3D"37.7" y=3D"1477" width=3D"4.6" height=3D"15.0" fill=3D"rgb(221,173,53)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.74" y=3D"1487.5" ></text>=0A</g>=0A<=
g >=0A<title>vcpu_enter_guest (133,987,142 samples, 0.04%)</title><rect x=
=3D"16.8" y=3D"309" width=3D"0.4" height=3D"15.0" fill=3D"rgb(248,68,13)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>get_user_pages_unlocked (1,211,902,461 samples, 0.33%)</title><re=
ct x=3D"55.0" y=3D"1541" width=3D"3.8" height=3D"15.0" fill=3D"rgb(243,127,=
21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.96" y=3D"1551.5" ></text>=0A</g>=
=0A<g >=0A<title>task_numa_work (132,959,376 samples, 0.04%)</title><rect x=
=3D"1170.9" y=3D"1957" width=3D"0.4" height=3D"15.0" fill=3D"rgb(234,53,8)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1967.5" ></text>=0A</g>=
=0A<g >=0A<title>schedule (147,308,806 samples, 0.04%)</title><rect x=3D"24=
.7" y=3D"85" width=3D"0.5" height=3D"15.0" fill=3D"rgb(236,22,4)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"27.71" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title=
>__do_fault (1,161,432,362 samples, 0.31%)</title><rect x=3D"38.6" y=3D"141=
3" width=3D"3.7" height=3D"15.0" fill=3D"rgb(233,137,50)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"41.55" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>kvm_f=
aultin_pfn (1,479,547,035 samples, 0.40%)</title><rect x=3D"142.3" y=3D"179=
7" width=3D"4.7" height=3D"15.0" fill=3D"rgb(227,6,23)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"145.27" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>__hand=
le_changed_spte (147,140,157 samples, 0.04%)</title><rect x=3D"812.2" y=3D"=
1877" width=3D"0.5" height=3D"15.0" fill=3D"rgb(215,21,49)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"815.19" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>in=
ternal_get_user_pages_fast (180,528,265 samples, 0.05%)</title><rect x=3D"1=
67.9" y=3D"1797" width=3D"0.6" height=3D"15.0" fill=3D"rgb(233,50,48)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"170.89" y=3D"1807.5" ></text>=0A</g>=0A<g =
>=0A<title>sched_clock_cpu (110,814,349 samples, 0.03%)</title><rect x=3D"2=
23.2" y=3D"1861" width=3D"0.3" height=3D"15.0" fill=3D"rgb(233,229,28)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"226.19" y=3D"1871.5" ></text>=0A</g>=0A<g =
>=0A<title>__srcu_read_unlock (278,292,029 samples, 0.08%)</title><rect x=
=3D"454.5" y=3D"1941" width=3D"0.9" height=3D"15.0" fill=3D"rgb(209,227,36)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"457.54" y=3D"1951.5" ></text>=0A</g>=
=0A<g >=0A<title>__schedule (40,046,245 samples, 0.01%)</title><rect x=3D"3=
1.4" y=3D"1301" width=3D"0.1" height=3D"15.0" fill=3D"rgb(248,96,20)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"34.41" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A=
<title>__update_idle_core (126,773,385 samples, 0.03%)</title><rect x=3D"25=
.2" y=3D"37" width=3D"0.4" height=3D"15.0" fill=3D"rgb(237,25,20)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"28.24" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<titl=
e>try_to_wake_up (776,533,745 samples, 0.21%)</title><rect x=3D"149.2" y=3D=
"1589" width=3D"2.5" height=3D"15.0" fill=3D"rgb(223,186,10)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"152.18" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__GI___ioctl (1,160,984,633 samples, 0.31%)</title><rect x=3D"84.5" y=3D"=
1813" width=3D"3.7" height=3D"15.0" fill=3D"rgb(213,213,35)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"87.47" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>[u=
nknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1237" w=
idth=3D"19.2" height=3D"15.0" fill=3D"rgb(251,191,5)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"1247.5" ></text>=0A</g>=0A<g >=0A<title>native_q=
ueued_spin_lock_slowpath (698,299,895 samples, 0.19%)</title><rect x=3D"38.=
6" y=3D"1301" width=3D"2.2" height=3D"15.0" fill=3D"rgb(242,4,12)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"41.60" y=3D"1311.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1=
573" width=3D"19.2" height=3D"15.0" fill=3D"rgb(220,222,26)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"13.00" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>gu=
p_pgd_range (180,528,265 samples, 0.05%)</title><rect x=3D"167.9" y=3D"1781=
" width=3D"0.6" height=3D"15.0" fill=3D"rgb(220,44,38)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"170.89" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>follow=
_page_pte (1,580,107,655 samples, 0.43%)</title><rect x=3D"489.4" y=3D"1829=
" width=3D"5.1" height=3D"15.0" fill=3D"rgb(245,141,10)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"492.43" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>poll_=
freewait (40,052,239,505 samples, 10.81%)</title><rect x=3D"902.9" y=3D"197=
3" width=3D"127.6" height=3D"15.0" fill=3D"rgb(239,197,18)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"905.90" y=3D"1983.5" >poll_freewait</text>=0A</g>=0A<g =
>=0A<title>syscall@plt (44,311,898 samples, 0.01%)</title><rect x=3D"439.9"=
 y=3D"2037" width=3D"0.1" height=3D"15.0" fill=3D"rgb(221,151,30)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"442.91" y=3D"2047.5" ></text>=0A</g>=0A<g >=0A<t=
itle>do_fault (2,423,604,255 samples, 0.65%)</title><rect x=3D"132.6" y=3D"=
1685" width=3D"7.7" height=3D"15.0" fill=3D"rgb(239,38,44)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"135.59" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>__=
rcu_read_lock (44,324,689 samples, 0.01%)</title><rect x=3D"438.3" y=3D"195=
7" width=3D"0.1" height=3D"15.0" fill=3D"rgb(243,122,21)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"441.28" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>[unk=
nown] (844,968,004 samples, 0.23%)</title><rect x=3D"10.0" y=3D"325" width=
=3D"2.7" height=3D"15.0" fill=3D"rgb(251,156,26)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"13.00" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_comm=
on (776,533,745 samples, 0.21%)</title><rect x=3D"149.2" y=3D"1621" width=
=3D"2.5" height=3D"15.0" fill=3D"rgb(206,61,50)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"152.18" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_l=
ock (1,715,578,680 samples, 0.46%)</title><rect x=3D"277.4" y=3D"1909" widt=
h=3D"5.4" height=3D"15.0" fill=3D"rgb(207,212,3)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"280.38" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_p=
ages (182,037,942 samples, 0.05%)</title><rect x=3D"12.7" y=3D"149" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(222,207,40)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"15.69" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_api=
c_timer_interrupt (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=
=3D"1525" width=3D"0.6" height=3D"15.0" fill=3D"rgb(241,138,3)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"114.26" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__do_fault (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"197"=
 width=3D"2.5" height=3D"15.0" fill=3D"rgb(217,144,19)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"29.48" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>do_sysca=
ll_64 (1,616,765,146 samples, 0.44%)</title><rect x=3D"88.2" y=3D"1797" wid=
th=3D"5.1" height=3D"15.0" fill=3D"rgb(241,47,52)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"91.17" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>workingset_a=
ge_nonresident (279,210,033 samples, 0.08%)</title><rect x=3D"127.1" y=3D"1=
701" width=3D"0.9" height=3D"15.0" fill=3D"rgb(235,214,10)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"130.08" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>hv=
a_to_pfn (1,111,133,729 samples, 0.30%)</title><rect x=3D"13.3" y=3D"213" w=
idth=3D"3.5" height=3D"15.0" fill=3D"rgb(252,213,25)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"16.27" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>check_pre=
emption_disabled (59,496,610 samples, 0.02%)</title><rect x=3D"869.1" y=3D"=
1861" width=3D"0.2" height=3D"15.0" fill=3D"rgb(220,203,18)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"872.12" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>m=
em_cgroup_from_task (529,002,897 samples, 0.14%)</title><rect x=3D"784.2" y=
=3D"1813" width=3D"1.7" height=3D"15.0" fill=3D"rgb(240,97,12)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"787.20" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__handle_mm_fault (1,473,606,899 samples, 0.40%)</title><rect x=3D"61.8" =
y=3D"1509" width=3D"4.6" height=3D"15.0" fill=3D"rgb(238,41,42)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"64.75" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__get_user_pages (2,491,551,090 samples, 0.67%)</title><rect x=3D"17.2" y=
=3D"213" width=3D"8.0" height=3D"15.0" fill=3D"rgb(205,104,4)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"20.24" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>=
get_user_pages_unlocked (145,741,482 samples, 0.04%)</title><rect x=3D"25.2=
" y=3D"245" width=3D"0.4" height=3D"15.0" fill=3D"rgb(207,56,4)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"28.18" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title=
>kvm_vcpu_ioctl (1,326,971,558 samples, 0.36%)</title><rect x=3D"108.6" y=
=3D"1813" width=3D"4.2" height=3D"15.0" fill=3D"rgb(249,118,48)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"111.62" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<tit=
le>do_raw_spin_lock (636,395,837 samples, 0.17%)</title><rect x=3D"50.6" y=
=3D"1349" width=3D"2.0" height=3D"15.0" fill=3D"rgb(241,204,21)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"53.59" y=3D"1359.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_vcpu_ioctl (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"=
405" width=3D"2.5" height=3D"15.0" fill=3D"rgb(239,155,41)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"29.48" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>asm_=
sysvec_apic_timer_interrupt (80,050,831 samples, 0.02%)</title><rect x=3D"7=
59.7" y=3D"1669" width=3D"0.3" height=3D"15.0" fill=3D"rgb(247,75,41)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"762.74" y=3D"1679.5" ></text>=0A</g>=0A<g =
>=0A<title>folio_mark_accessed (203,226,416 samples, 0.05%)</title><rect x=
=3D"66.5" y=3D"1573" width=3D"0.6" height=3D"15.0" fill=3D"rgb(222,83,26)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"69.50" y=3D"1583.5" ></text>=0A</g>=0A<g=
 >=0A<title>sysvec_apic_timer_interrupt (199,463,518 samples, 0.05%)</title=
><rect x=3D"903.3" y=3D"1925" width=3D"0.7" height=3D"15.0" fill=3D"rgb(212=
,129,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.33" y=3D"1935.5" ></text>=
=0A</g>=0A<g >=0A<title>do_fault (2,131,350,080 samples, 0.58%)</title><rec=
t x=3D"112.9" y=3D"1637" width=3D"6.7" height=3D"15.0" fill=3D"rgb(215,10,4=
4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>__cond_resched_rwlock_write (110,803,799 samples, 0.03%)</=
title><rect x=3D"1170.9" y=3D"1829" width=3D"0.3" height=3D"15.0" fill=3D"r=
gb(210,8,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1839.5" ></t=
ext>=0A</g>=0A<g >=0A<title>scheduler_tick (88,658,279 samples, 0.02%)</tit=
le><rect x=3D"274.1" y=3D"1797" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
30,213,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.06" y=3D"1807.5" ></text=
>=0A</g>=0A<g >=0A<title>make_spte (123,852,408 samples, 0.03%)</title><rec=
t x=3D"92.4" y=3D"1653" width=3D"0.4" height=3D"15.0" fill=3D"rgb(236,192,2=
5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"95.36" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>native_write_msr (40,455,198 samples, 0.01%)</title><rect =
x=3D"834.7" y=3D"1925" width=3D"0.1" height=3D"15.0" fill=3D"rgb(227,60,54)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.69" y=3D"1935.5" ></text>=0A</g>=
=0A<g >=0A<title>__hrtimer_run_queues (110,812,663 samples, 0.03%)</title><=
rect x=3D"274.0" y=3D"1861" width=3D"0.3" height=3D"15.0" fill=3D"rgb(211,2=
9,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"276.99" y=3D"1871.5" ></text>=0A</=
g>=0A<g >=0A<title>handle_mm_fault (133,987,142 samples, 0.04%)</title><rec=
t x=3D"16.8" y=3D"181" width=3D"0.4" height=3D"15.0" fill=3D"rgb(249,136,0)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"191.5" ></text>=0A</g>=0A<=
g >=0A<title>kvm_sched_in (184,758,529 samples, 0.05%)</title><rect x=3D"76=
6.1" y=3D"1669" width=3D"0.6" height=3D"15.0" fill=3D"rgb(232,195,31)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"769.11" y=3D"1679.5" ></text>=0A</g>=0A<g =
>=0A<title>__wake_up_common_lock (66,326,347 samples, 0.02%)</title><rect x=
=3D"16.8" y=3D"69" width=3D"0.2" height=3D"15.0" fill=3D"rgb(240,152,51)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"79.5" ></text>=0A</g>=0A<g >=
=0A<title>[unknown] (1,027,005,946 samples, 0.28%)</title><rect x=3D"10.0" =
y=3D"389" width=3D"3.3" height=3D"15.0" fill=3D"rgb(240,193,26)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"13.00" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title=
>kvm_pfn_to_refcounted_page (47,964,076 samples, 0.01%)</title><rect x=3D"7=
3.7" y=3D"1589" width=3D"0.1" height=3D"15.0" fill=3D"rgb(226,95,30)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"76.68" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A=
<title>kvm_mmu_page_fault (98,073,756 samples, 0.03%)</title><rect x=3D"11.=
8" y=3D"101" width=3D"0.3" height=3D"15.0" fill=3D"rgb(243,198,44)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"14.76" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>_raw_spin_unlock_irq (136,627,893 samples, 0.04%)</title><rect x=3D"706=
.2" y=3D"1717" width=3D"0.5" height=3D"15.0" fill=3D"rgb(239,125,49)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"709.22" y=3D"1727.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_irqsave (528,453,476 samples, 0.14%)</title><rect =
x=3D"169.1" y=3D"1653" width=3D"1.6" height=3D"15.0" fill=3D"rgb(206,172,43=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"172.05" y=3D"1663.5" ></text>=0A</g>=
=0A<g >=0A<title>filemap_remove_folio (1,494,333,158 samples, 0.40%)</title=
><rect x=3D"1178.8" y=3D"1829" width=3D"4.7" height=3D"15.0" fill=3D"rgb(21=
1,96,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.78" y=3D"1839.5" ></text>=
=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (2,637,779,941 samples, 0.71%)</tit=
le><rect x=3D"112.8" y=3D"1845" width=3D"8.4" height=3D"15.0" fill=3D"rgb(2=
50,216,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.85" y=3D"1855.5" ></text=
>=0A</g>=0A<g >=0A<title>preempt_count_add (369,403,167 samples, 0.10%)</ti=
tle><rect x=3D"885.6" y=3D"1925" width=3D"1.1" height=3D"15.0" fill=3D"rgb(=
214,37,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"888.57" y=3D"1935.5" ></text=
>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (1,804,249,065 samples, 0.4=
9%)</title><rect x=3D"277.2" y=3D"1925" width=3D"5.7" height=3D"15.0" fill=
=3D"rgb(226,138,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"280.17" y=3D"1935.5=
" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (3,348,716,533 samples, 0.90=
%)</title><rect x=3D"147.5" y=3D"1973" width=3D"10.7" height=3D"15.0" fill=
=3D"rgb(211,2,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.55" y=3D"1983.5" =
></text>=0A</g>=0A<g >=0A<title>psi_task_switch (76,183,637 samples, 0.02%)=
</title><rect x=3D"24.9" y=3D"53" width=3D"0.3" height=3D"15.0" fill=3D"rgb=
(244,147,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"27.93" y=3D"63.5" ></text>=
=0A</g>=0A<g >=0A<title>do_fault (1,112,111,832 samples, 0.30%)</title><rec=
t x=3D"168.5" y=3D"1749" width=3D"3.6" height=3D"15.0" fill=3D"rgb(243,120,=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"171.53" y=3D"1759.5" ></text>=0A</g>=
=0A<g >=0A<title>__ia32_sys_gettid (88,657,886 samples, 0.02%)</title><rect=
 x=3D"438.2" y=3D"1989" width=3D"0.3" height=3D"15.0" fill=3D"rgb(223,103,3=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.21" y=3D"1999.5" ></text>=0A</g>=
=0A<g >=0A<title>vcpu_enter_guest (123,122,609 samples, 0.03%)</title><rect=
 x=3D"11.4" y=3D"117" width=3D"0.4" height=3D"15.0" fill=3D"rgb(211,130,47)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"14.37" y=3D"127.5" ></text>=0A</g>=0A<=
g >=0A<title>do_raw_spin_lock (129,373,983 samples, 0.03%)</title><rect x=
=3D"126.5" y=3D"1573" width=3D"0.4" height=3D"15.0" fill=3D"rgb(207,205,44)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"129.52" y=3D"1583.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_unlock (134,642,807 samples, 0.04%)</title><re=
ct x=3D"1034.2" y=3D"1941" width=3D"0.5" height=3D"15.0" fill=3D"rgb(218,1,=
19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1037.25" y=3D"1951.5" ></text>=0A</=
g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (165,602,732 samples, 0=
.04%)</title><rect x=3D"65.7" y=3D"1397" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(241,169,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"68.70" y=3D"1407.5" =
></text>=0A</g>=0A<g >=0A<title>follow_page_pte (180,226,188 samples, 0.05%=
)</title><rect x=3D"128.3" y=3D"1701" width=3D"0.6" height=3D"15.0" fill=3D=
"rgb(232,65,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.32" y=3D"1711.5" ><=
/text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (56,062,552,752 samples=
, 15.14%)</title><rect x=3D"526.1" y=3D"1717" width=3D"178.6" height=3D"15.=
0" fill=3D"rgb(227,52,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"529.11" y=3D"=
1727.5" >__wake_up_common_lock</text>=0A</g>=0A<g >=0A<title>vmx_get_mt_mas=
k (54,392,863 samples, 0.01%)</title><rect x=3D"130.8" y=3D"1733" width=3D"=
0.1" height=3D"15.0" fill=3D"rgb(246,88,34)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"133.78" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<title>evict (3,024,182,=
225 samples, 0.82%)</title><rect x=3D"1174.1" y=3D"1909" width=3D"9.7" heig=
ht=3D"15.0" fill=3D"rgb(205,57,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177=
.12" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (68=
6,869,550 samples, 0.19%)</title><rect x=3D"143.5" y=3D"1621" width=3D"2.2"=
 height=3D"15.0" fill=3D"rgb(241,174,49)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"146.53" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>do_fault (1,523,13=
6,454 samples, 0.41%)</title><rect x=3D"122.2" y=3D"1653" width=3D"4.9" hei=
ght=3D"15.0" fill=3D"rgb(233,213,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"12=
5.22" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (26=
9,433,971 samples, 0.07%)</title><rect x=3D"262.3" y=3D"1893" width=3D"0.9"=
 height=3D"15.0" fill=3D"rgb(252,121,29)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"265.31" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irq=
 (155,142,335 samples, 0.04%)</title><rect x=3D"226.6" y=3D"1941" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(244,151,51)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"229.58" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>vmx_flush_tlb_al=
l (84,207,089 samples, 0.02%)</title><rect x=3D"459.8" y=3D"1941" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(227,27,7)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"462.77" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (=
2,205,405,843 samples, 0.60%)</title><rect x=3D"148.5" y=3D"1765" width=3D"=
7.0" height=3D"15.0" fill=3D"rgb(210,161,39)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"151.45" y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040=
,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"885" width=3D"19.2" h=
eight=3D"15.0" fill=3D"rgb(206,117,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
13.00" y=3D"895.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (=
559,180,450 samples, 0.15%)</title><rect x=3D"75.0" y=3D"1429" width=3D"1.8=
" height=3D"15.0" fill=3D"rgb(220,93,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"78.05" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock =
(1,200,111,144 samples, 0.32%)</title><rect x=3D"122.7" y=3D"1573" width=3D=
"3.8" height=3D"15.0" fill=3D"rgb(222,81,3)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"125.70" y=3D"1583.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (3=
05,687,955 samples, 0.08%)</title><rect x=3D"120.2" y=3D"1749" width=3D"1.0=
" height=3D"15.0" fill=3D"rgb(220,64,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"123.23" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1,1=
87,074,108 samples, 0.32%)</title><rect x=3D"122.7" y=3D"1541" width=3D"3.8=
" height=3D"15.0" fill=3D"rgb(251,10,18)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"125.74" y=3D"1551.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault=
 (1,129,761,195 samples, 0.31%)</title><rect x=3D"80.8" y=3D"1669" width=3D=
"3.6" height=3D"15.0" fill=3D"rgb(231,71,41)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"83.82" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>change_prot_numa =
(88,418,539 samples, 0.02%)</title><rect x=3D"897.1" y=3D"1941" width=3D"0.=
3" height=3D"15.0" fill=3D"rgb(249,21,46)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"900.12" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault =
(2,007,086,022 samples, 0.54%)</title><rect x=3D"160.3" y=3D"1749" width=3D=
"6.4" height=3D"15.0" fill=3D"rgb(214,188,9)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"163.26" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>__cond_resched (=
60,980,082 samples, 0.02%)</title><rect x=3D"468.5" y=3D"1861" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(241,148,6)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"471.52" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (=
1,103,910,496 samples, 0.30%)</title><rect x=3D"50.3" y=3D"1509" width=3D"3=
.5" height=3D"15.0" fill=3D"rgb(214,109,13)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"53.27" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_unl=
ocked (700,745,341 samples, 0.19%)</title><rect x=3D"29.3" y=3D"1461" width=
=3D"2.2" height=3D"15.0" fill=3D"rgb(248,41,25)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"32.31" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (1,=
417,843,408 samples, 0.38%)</title><rect x=3D"42.9" y=3D"1429" width=3D"4.5=
" height=3D"15.0" fill=3D"rgb(225,17,18)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"45.86" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (315,4=
91,762 samples, 0.09%)</title><rect x=3D"131.5" y=3D"1813" width=3D"1.0" he=
ight=3D"15.0" fill=3D"rgb(220,168,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13=
4.51" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_read_lock (584,62=
9,374 samples, 0.16%)</title><rect x=3D"464.7" y=3D"1893" width=3D"1.9" hei=
ght=3D"15.0" fill=3D"rgb(225,11,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"467=
.71" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (404,205,470 s=
amples, 0.11%)</title><rect x=3D"77.4" y=3D"1429" width=3D"1.3" height=3D"1=
5.0" fill=3D"rgb(212,43,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"80.39" y=3D=
"1439.5" ></text>=0A</g>=0A<g >=0A<title>__check_object_size (44,322,242 sa=
mples, 0.01%)</title><rect x=3D"901.4" y=3D"1973" width=3D"0.1" height=3D"1=
5.0" fill=3D"rgb(249,156,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"904.40" y=
=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (159,314,940 sa=
mples, 0.04%)</title><rect x=3D"10.8" y=3D"133" width=3D"0.5" height=3D"15.=
0" fill=3D"rgb(238,74,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"1=
43.5" ></text>=0A</g>=0A<g >=0A<title>rcu_note_context_switch (359,747,861 =
samples, 0.10%)</title><rect x=3D"97.0" y=3D"1477" width=3D"1.2" height=3D"=
15.0" fill=3D"rgb(245,154,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"100.03" y=
=3D"1487.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (133,987,142 sa=
mples, 0.04%)</title><rect x=3D"16.8" y=3D"293" width=3D"0.4" height=3D"15.=
0" fill=3D"rgb(219,19,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"3=
03.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_pages (61,757,117 samples,=
 0.02%)</title><rect x=3D"29.0" y=3D"277" width=3D"0.2" height=3D"15.0" fil=
l=3D"rgb(244,174,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"287.5"=
 ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (700,745,341 samples, 0.19%)</t=
itle><rect x=3D"29.3" y=3D"1477" width=3D"2.2" height=3D"15.0" fill=3D"rgb(=
212,218,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.31" y=3D"1487.5" ></text=
>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (911,547,376 samples, 0.25%)</titl=
e><rect x=3D"29.2" y=3D"1605" width=3D"2.9" height=3D"15.0" fill=3D"rgb(239=
,197,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.24" y=3D"1615.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1,423,413,484 samples, 0.38%)</ti=
tle><rect x=3D"160.3" y=3D"1621" width=3D"4.5" height=3D"15.0" fill=3D"rgb(=
240,220,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=3D"1631.5" ></text=
>=0A</g>=0A<g >=0A<title>mmput (202,678,194 samples, 0.05%)</title><rect x=
=3D"251.3" y=3D"1957" width=3D"0.6" height=3D"15.0" fill=3D"rgb(252,50,38)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"254.27" y=3D"1967.5" ></text>=0A</g>=0A=
<g >=0A<title>follow_page_pte (138,806,509 samples, 0.04%)</title><rect x=
=3D"42.4" y=3D"1477" width=3D"0.5" height=3D"15.0" fill=3D"rgb(217,8,52)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"45.42" y=3D"1487.5" ></text>=0A</g>=0A<g =
>=0A<title>preempt_count_sub (429,745,658 samples, 0.12%)</title><rect x=3D=
"781.3" y=3D"1701" width=3D"1.4" height=3D"15.0" fill=3D"rgb(243,217,0)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"784.30" y=3D"1711.5" ></text>=0A</g>=0A<g =
>=0A<title>vcpu_enter_guest (1,488,009,723 samples, 0.40%)</title><rect x=
=3D"37.7" y=3D"1589" width=3D"4.7" height=3D"15.0" fill=3D"rgb(254,100,32)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"40.67" y=3D"1599.5" ></text>=0A</g>=0A<=
g >=0A<title>userfaultfd_wake_function (1,800,626,615 samples, 0.49%)</titl=
e><rect x=3D"206.0" y=3D"1925" width=3D"5.7" height=3D"15.0" fill=3D"rgb(20=
7,90,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"208.95" y=3D"1935.5" ></text>=
=0A</g>=0A<g >=0A<title>__GI___ioctl (2,780,619,464 samples, 0.75%)</title>=
<rect x=3D"59.1" y=3D"1749" width=3D"8.8" height=3D"15.0" fill=3D"rgb(238,1=
39,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.06" y=3D"1759.5" ></text>=0A<=
/g>=0A<g >=0A<title>__x64_sys_ioctl (1,143,809,245 samples, 0.31%)</title><=
rect x=3D"84.5" y=3D"1765" width=3D"3.7" height=3D"15.0" fill=3D"rgb(207,10=
6,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.52" y=3D"1775.5" ></text>=0A</=
g>=0A<g >=0A<title>kvm_faultin_pfn (1,821,514,697 samples, 0.49%)</title><r=
ect x=3D"42.4" y=3D"1541" width=3D"5.8" height=3D"15.0" fill=3D"rgb(208,137=
,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.42" y=3D"1551.5" ></text>=0A</g>=
=0A<g >=0A<title>hva_to_pfn (1,046,776,258 samples, 0.28%)</title><rect x=
=3D"80.8" y=3D"1621" width=3D"3.4" height=3D"15.0" fill=3D"rgb(251,203,45)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.82" y=3D"1631.5" ></text>=0A</g>=0A<=
g >=0A<title>check_preemption_disabled (66,499,867 samples, 0.02%)</title><=
rect x=3D"431.5" y=3D"1909" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,1=
78,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434.47" y=3D"1919.5" ></text>=0A<=
/g>=0A<g >=0A<title>entry_SYSCALL_64 (22,636,122,902 samples, 6.11%)</title=
><rect x=3D"180.2" y=3D"2021" width=3D"72.2" height=3D"15.0" fill=3D"rgb(23=
3,12,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"183.25" y=3D"2031.5" >entry_SY=
..</text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,283,638,963 samples, 0.=
35%)</title><rect x=3D"49.8" y=3D"1605" width=3D"4.1" height=3D"15.0" fill=
=3D"rgb(227,6,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1615.5" >=
</text>=0A</g>=0A<g >=0A<title>handle_mm_fault (61,757,117 samples, 0.02%)<=
/title><rect x=3D"29.0" y=3D"261" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(205,93,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"271.5" ></text>=
=0A</g>=0A<g >=0A<title>__schedule (488,912,619 samples, 0.13%)</title><rec=
t x=3D"96.8" y=3D"1493" width=3D"1.5" height=3D"15.0" fill=3D"rgb(242,58,49=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"99.75" y=3D"1503.5" ></text>=0A</g>=
=0A<g >=0A<title>do_syscall_64 (2,063,122,219 samples, 0.56%)</title><rect =
x=3D"74.1" y=3D"1749" width=3D"6.5" height=3D"15.0" fill=3D"rgb(233,154,3)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.08" y=3D"1759.5" ></text>=0A</g>=0A<=
g >=0A<title>native_queued_spin_lock_slowpath (107,243,065 samples, 0.03%)<=
/title><rect x=3D"57.8" y=3D"1381" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(238,185,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"60.85" y=3D"1391.5" ></te=
xt>=0A</g>=0A<g >=0A<title>check_preemption_disabled (309,327,693 samples, =
0.08%)</title><rect x=3D"156.3" y=3D"1701" width=3D"1.0" height=3D"15.0" fi=
ll=3D"rgb(227,81,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"159.29" y=3D"1711.=
5" ></text>=0A</g>=0A<g >=0A<title>__fget_light (421,117,377 samples, 0.11%=
)</title><rect x=3D"255.7" y=3D"1957" width=3D"1.4" height=3D"15.0" fill=3D=
"rgb(247,77,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"258.72" y=3D"1967.5" ></=
text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (1,319,411,362 samples=
, 0.36%)</title><rect x=3D"49.8" y=3D"1637" width=3D"4.2" height=3D"15.0" f=
ill=3D"rgb(246,199,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.75" y=3D"1647=
.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (1,655,662,953 samples=
, 0.45%)</title><rect x=3D"142.3" y=3D"1941" width=3D"5.2" height=3D"15.0" =
fill=3D"rgb(222,143,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"145.27" y=3D"19=
51.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,312,783,414 sample=
s, 0.35%)</title><rect x=3D"167.9" y=3D"1845" width=3D"4.2" height=3D"15.0"=
 fill=3D"rgb(236,149,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.89" y=3D"1=
855.5" ></text>=0A</g>=0A<g >=0A<title>task_tick_fair (88,645,508 samples, =
0.02%)</title><rect x=3D"903.5" y=3D"1797" width=3D"0.3" height=3D"15.0" fi=
ll=3D"rgb(213,1,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.54" y=3D"1807.5=
" ></text>=0A</g>=0A<g >=0A<title>[unknown] (5,963,734,552 samples, 1.61%)<=
/title><rect x=3D"10.0" y=3D"485" width=3D"19.0" height=3D"15.0" fill=3D"rg=
b(249,51,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"495.5" ></text=
>=0A</g>=0A<g >=0A<title>shmem_fault (2,007,086,022 samples, 0.54%)</title>=
<rect x=3D"160.3" y=3D"1701" width=3D"6.4" height=3D"15.0" fill=3D"rgb(213,=
127,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"163.26" y=3D"1711.5" ></text>=0A=
</g>=0A<g >=0A<title>__pagevec_release (1,000,640,146 samples, 0.27%)</titl=
e><rect x=3D"1174.2" y=3D"1845" width=3D"3.2" height=3D"15.0" fill=3D"rgb(2=
21,72,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1177.19" y=3D"1855.5" ></text=
>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,111,133,729 samples, 0.=
30%)</title><rect x=3D"13.3" y=3D"197" width=3D"3.5" height=3D"15.0" fill=
=3D"rgb(210,140,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"207.5" =
></text>=0A</g>=0A<g >=0A<title>xas_clear_mark (88,189,210 samples, 0.02%)<=
/title><rect x=3D"1181.8" y=3D"1781" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(224,20,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1184.79" y=3D"1791.5" ></=
text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (132,976,269 samples, 0.0=
4%)</title><rect x=3D"1032.5" y=3D"1797" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(206,96,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.50" y=3D"1807.5"=
 ></text>=0A</g>=0A<g >=0A<title>update_curr (310,476,759 samples, 0.08%)</=
title><rect x=3D"91.1" y=3D"1429" width=3D"0.9" height=3D"15.0" fill=3D"rgb=
(208,159,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"94.06" y=3D"1439.5" ></tex=
t>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (61,757,117 samples, 0.02%)</t=
itle><rect x=3D"29.0" y=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
08,200,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"351.5" ></text>=
=0A</g>=0A<g >=0A<title>__GI___ioctl (1,111,133,729 samples, 0.30%)</title>=
<rect x=3D"13.3" y=3D"389" width=3D"3.5" height=3D"15.0" fill=3D"rgb(253,55=
,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"399.5" ></text>=0A</g>=
=0A<g >=0A<title>do_fault (1,161,432,362 samples, 0.31%)</title><rect x=3D"=
38.6" y=3D"1429" width=3D"3.7" height=3D"15.0" fill=3D"rgb(206,40,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"41.55" y=3D"1439.5" ></text>=0A</g>=0A<g >=
=0A<title>__handle_mm_fault (1,026,979,445 samples, 0.28%)</title><rect x=
=3D"84.6" y=3D"1573" width=3D"3.3" height=3D"15.0" fill=3D"rgb(210,150,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"1583.5" ></text>=0A</g>=0A<=
g >=0A<title>hva_to_pfn (1,479,547,035 samples, 0.40%)</title><rect x=3D"14=
2.3" y=3D"1781" width=3D"4.7" height=3D"15.0" fill=3D"rgb(240,17,2)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"145.27" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A=
<title>do_fault (2,007,086,022 samples, 0.54%)</title><rect x=3D"160.3" y=
=3D"1733" width=3D"6.4" height=3D"15.0" fill=3D"rgb(225,187,34)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"163.26" y=3D"1743.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_vcpu_ioctl (2,549,679,159 samples, 0.69%)</title><rect x=3D"59.8" y=
=3D"1685" width=3D"8.1" height=3D"15.0" fill=3D"rgb(241,112,8)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"62.80" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title=
>get_user_pages_unlocked (96,569,714,909 samples, 26.07%)</title><rect x=3D=
"482.8" y=3D"1861" width=3D"307.7" height=3D"15.0" fill=3D"rgb(211,58,38)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"485.80" y=3D"1871.5" >get_user_pages_unl=
ocked</text>=0A</g>=0A<g >=0A<title>folio_mark_accessed (42,918,648 samples=
, 0.01%)</title><rect x=3D"189.9" y=3D"1861" width=3D"0.1" height=3D"15.0" =
fill=3D"rgb(210,211,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"192.87" y=3D"18=
71.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (133,987,142 samples=
, 0.04%)</title><rect x=3D"16.8" y=3D"85" width=3D"0.4" height=3D"15.0" fil=
l=3D"rgb(220,115,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"95.5" =
></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</t=
itle><rect x=3D"10.0" y=3D"1029" width=3D"19.2" height=3D"15.0" fill=3D"rgb=
(205,104,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1039.5" ></tex=
t>=0A</g>=0A<g >=0A<title>vmx_handle_exit (816,273,154 samples, 0.22%)</tit=
le><rect x=3D"29.2" y=3D"1541" width=3D"2.6" height=3D"15.0" fill=3D"rgb(24=
4,26,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.24" y=3D"1551.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (107,243,065 samples, 0.03%)</titl=
e><rect x=3D"57.8" y=3D"1397" width=3D"0.4" height=3D"15.0" fill=3D"rgb(206=
,226,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"60.85" y=3D"1407.5" ></text>=
=0A</g>=0A<g >=0A<title>[unknown] (844,968,004 samples, 0.23%)</title><rect=
 x=3D"10.0" y=3D"309" width=3D"2.7" height=3D"15.0" fill=3D"rgb(244,88,29)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>native_queued_spin_lock_slowpath (67,112,045 samples, 0.02%)</t=
itle><rect x=3D"111.9" y=3D"1525" width=3D"0.2" height=3D"15.0" fill=3D"rgb=
(218,50,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.88" y=3D"1535.5" ></text=
>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,319,411,362 samples, 0.36%)</t=
itle><rect x=3D"49.8" y=3D"1621" width=3D"4.2" height=3D"15.0" fill=3D"rgb(=
240,66,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.75" y=3D"1631.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (2,063,122,219 samples, 0.56%)</titl=
e><rect x=3D"74.1" y=3D"1717" width=3D"6.5" height=3D"15.0" fill=3D"rgb(227=
,173,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.08" y=3D"1727.5" ></text>=
=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (242,568,316 samples, 0.07%)</title>=
<rect x=3D"157.4" y=3D"1845" width=3D"0.8" height=3D"15.0" fill=3D"rgb(227,=
193,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"160.38" y=3D"1855.5" ></text>=
=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (21,977,792,691 samples, 5.93%)</ti=
tle><rect x=3D"181.9" y=3D"1989" width=3D"70.0" height=3D"15.0" fill=3D"rgb=
(234,139,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"184.90" y=3D"1999.5" >__x6=
4_s..</text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (340,536,211 samples, =
0.09%)</title><rect x=3D"110.2" y=3D"1509" width=3D"1.1" height=3D"15.0" fi=
ll=3D"rgb(233,131,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"113.18" y=3D"1519=
.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,604,157,291 samples,=
 0.43%)</title><rect x=3D"93.4" y=3D"1733" width=3D"5.1" height=3D"15.0" fi=
ll=3D"rgb(252,72,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.39" y=3D"1743.5=
" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (338,774,002 samples, 0.09=
%)</title><rect x=3D"36.5" y=3D"1525" width=3D"1.1" height=3D"15.0" fill=3D=
"rgb(206,120,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.49" y=3D"1535.5" ><=
/text>=0A</g>=0A<g >=0A<title>__do_fault (2,079,126,509 samples, 0.56%)</ti=
tle><rect x=3D"100.0" y=3D"1589" width=3D"6.6" height=3D"15.0" fill=3D"rgb(=
234,108,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.98" y=3D"1599.5" ></tex=
t>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (705,038,517 sam=
ples, 0.19%)</title><rect x=3D"33.4" y=3D"1285" width=3D"2.2" height=3D"15.=
0" fill=3D"rgb(254,28,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"36.38" y=3D"1=
295.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (129,467,492=
 samples, 0.03%)</title><rect x=3D"10.4" y=3D"85" width=3D"0.4" height=3D"1=
5.0" fill=3D"rgb(215,191,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=
=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (182,037,942 sampl=
es, 0.05%)</title><rect x=3D"12.7" y=3D"293" width=3D"0.6" height=3D"15.0" =
fill=3D"rgb(206,69,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.69" y=3D"303.=
5" ></text>=0A</g>=0A<g >=0A<title>try_grab_page (524,053,584 samples, 0.14=
%)</title><rect x=3D"492.8" y=3D"1813" width=3D"1.7" height=3D"15.0" fill=
=3D"rgb(228,46,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"495.79" y=3D"1823.5"=
 ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (140,877,887,887 samples, 38=
.03%)</title><rect x=3D"447.5" y=3D"2021" width=3D"448.8" height=3D"15.0" f=
ill=3D"rgb(252,100,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"450.46" y=3D"203=
1.5" >do_syscall_64</text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_irq (66,=
060,434 samples, 0.02%)</title><rect x=3D"1183.3" y=3D"1813" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(224,23,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1186.26" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (790,301=
,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"469" width=3D"2.5" height=
=3D"15.0" fill=3D"rgb(249,215,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48=
" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (2,637,779,941 =
samples, 0.71%)</title><rect x=3D"112.8" y=3D"1861" width=3D"8.4" height=3D=
"15.0" fill=3D"rgb(253,32,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.85" y=
=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (44,357,024 s=
amples, 0.01%)</title><rect x=3D"1170.5" y=3D"1925" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(231,32,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.49" =
y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,833,266,047 =
samples, 0.49%)</title><rect x=3D"68.2" y=3D"1701" width=3D"5.9" height=3D"=
15.0" fill=3D"rgb(212,193,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.24" y=
=3D"1711.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (1,590,623,571 =
samples, 0.43%)</title><rect x=3D"54.0" y=3D"1685" width=3D"5.1" height=3D"=
15.0" fill=3D"rgb(252,184,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"57.00" y=
=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (845,221=
,885 samples, 0.23%)</title><rect x=3D"55.2" y=3D"1381" width=3D"2.6" heigh=
t=3D"15.0" fill=3D"rgb(243,61,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"58.16=
" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>folio_activate (230,736,897 =
samples, 0.06%)</title><rect x=3D"48.2" y=3D"1509" width=3D"0.8" height=3D"=
15.0" fill=3D"rgb(221,122,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"51.22" y=
=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (1,026,979,445 samp=
les, 0.28%)</title><rect x=3D"84.6" y=3D"1525" width=3D"3.3" height=3D"15.0=
" fill=3D"rgb(227,205,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.63" y=3D"15=
35.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.6=
3%)</title><rect x=3D"10.0" y=3D"853" width=3D"19.2" height=3D"15.0" fill=
=3D"rgb(242,45,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"863.5" >=
</text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (259,024,777 samples, 0.07%=
)</title><rect x=3D"121.4" y=3D"1669" width=3D"0.8" height=3D"15.0" fill=3D=
"rgb(217,83,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"124.39" y=3D"1679.5" ><=
/text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (129,823,438=
 samples, 0.04%)</title><rect x=3D"52.6" y=3D"1365" width=3D"0.4" height=3D=
"15.0" fill=3D"rgb(225,40,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"55.62" y=
=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>pollwake (3,037,362,804 samples=
, 0.82%)</title><rect x=3D"527.6" y=3D"1685" width=3D"9.7" height=3D"15.0" =
fill=3D"rgb(241,164,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"530.59" y=3D"16=
95.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,080,385,713 samples, 0.=
29%)</title><rect x=3D"33.0" y=3D"1493" width=3D"3.4" height=3D"15.0" fill=
=3D"rgb(254,170,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.98" y=3D"1503.5" =
></text>=0A</g>=0A<g >=0A<title>__schedule (210,342,010 samples, 0.06%)</ti=
tle><rect x=3D"83.4" y=3D"1445" width=3D"0.7" height=3D"15.0" fill=3D"rgb(2=
12,202,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.43" y=3D"1455.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (790,301,371 samples, 0.21%)</ti=
tle><rect x=3D"26.5" y=3D"325" width=3D"2.5" height=3D"15.0" fill=3D"rgb(23=
4,185,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.48" y=3D"335.5" ></text>=
=0A</g>=0A<g >=0A<title>__get_user_pages (2,214,703,838 samples, 0.60%)</ti=
tle><rect x=3D"99.5" y=3D"1653" width=3D"7.1" height=3D"15.0" fill=3D"rgb(2=
21,4,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102.55" y=3D"1663.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (175,743,420 samples, 0.05%)</titl=
e><rect x=3D"145.7" y=3D"1621" width=3D"0.6" height=3D"15.0" fill=3D"rgb(23=
1,42,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"148.72" y=3D"1631.5" ></text>=
=0A</g>=0A<g >=0A<title>load_balance (51,506,394 samples, 0.01%)</title><re=
ct x=3D"96.9" y=3D"1445" width=3D"0.1" height=3D"15.0" fill=3D"rgb(251,123,=
1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"99.86" y=3D"1455.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_unlock (88,644,132 samples, 0.02%)</title><rec=
t x=3D"274.5" y=3D"1925" width=3D"0.3" height=3D"15.0" fill=3D"rgb(217,135,=
45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.55" y=3D"1935.5" ></text>=0A</g=
>=0A<g >=0A<title>dequeue_task_fair (290,842,992 samples, 0.08%)</title><re=
ct x=3D"41.2" y=3D"1317" width=3D"0.9" height=3D"15.0" fill=3D"rgb(210,30,3=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"44.21" y=3D"1327.5" ></text>=0A</g>=
=0A<g >=0A<title>__get_user_pages (1,418,382,595 samples, 0.38%)</title><re=
ct x=3D"93.8" y=3D"1637" width=3D"4.5" height=3D"15.0" fill=3D"rgb(216,49,1=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.79" y=3D"1647.5" ></text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (598,529,059 samples, 0.16%)</title><rect=
 x=3D"215.4" y=3D"1861" width=3D"1.9" height=3D"15.0" fill=3D"rgb(247,168,1=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"218.44" y=3D"1871.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"1493" width=3D"19.2" height=3D"15.0" fill=3D"rgb(233,149,16)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1503.5" ></text>=0A</g>=0A<g =
>=0A<title>native_queued_spin_lock_slowpath (40,943,540 samples, 0.01%)</ti=
tle><rect x=3D"164.8" y=3D"1637" width=3D"0.1" height=3D"15.0" fill=3D"rgb(=
253,200,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.80" y=3D"1647.5" ></text=
>=0A</g>=0A<g >=0A<title>cgroup_rstat_updated (105,626,383 samples, 0.03%)<=
/title><rect x=3D"496.4" y=3D"1797" width=3D"0.3" height=3D"15.0" fill=3D"r=
gb(206,46,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"499.39" y=3D"1807.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (3,063,052,576 samples, 0.83%)</=
title><rect x=3D"132.5" y=3D"1893" width=3D"9.8" height=3D"15.0" fill=3D"rg=
b(233,200,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.52" y=3D"1903.5" ></t=
ext>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (52,471,610,878 samples,=
 14.17%)</title><rect x=3D"537.3" y=3D"1701" width=3D"167.1" height=3D"15.0=
" fill=3D"rgb(242,69,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"540.26" y=3D"17=
11.5" >_raw_spin_lock_irqsave</text>=0A</g>=0A<g >=0A<title>vmx_handle_exit=
 (3,073,845,719 samples, 0.83%)</title><rect x=3D"147.6" y=3D"1861" width=
=3D"9.8" height=3D"15.0" fill=3D"rgb(220,225,37)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"150.56" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCAL=
L_64 (59,449,801 samples, 0.02%)</title><rect x=3D"12.5" y=3D"277" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(249,88,5)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"15.50" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_hugepage_ad=
just (279,557,039 samples, 0.08%)</title><rect x=3D"78.8" y=3D"1605" width=
=3D"0.8" height=3D"15.0" fill=3D"rgb(210,33,21)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"81.75" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>syscall_trace_=
enter.isra.17 (66,501,992 samples, 0.02%)</title><rect x=3D"1172.1" y=3D"20=
05" width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,130,29)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1175.15" y=3D"2015.5" ></text>=0A</g>=0A<g >=0A<title>_r=
aw_spin_lock (38,994,185 samples, 0.01%)</title><rect x=3D"490.9" y=3D"1813=
" width=3D"0.1" height=3D"15.0" fill=3D"rgb(251,217,1)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"493.90" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>schedu=
le (68,495,474 samples, 0.02%)</title><rect x=3D"66.2" y=3D"1413" width=3D"=
0.2" height=3D"15.0" fill=3D"rgb(217,116,6)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"69.23" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gf=
p (1,026,979,445 samples, 0.28%)</title><rect x=3D"84.6" y=3D"1509" width=
=3D"3.3" height=3D"15.0" fill=3D"rgb(239,222,45)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"87.63" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_gu=
est (1,657,361,967 samples, 0.45%)</title><rect x=3D"93.4" y=3D"1749" width=
=3D"5.3" height=3D"15.0" fill=3D"rgb(224,119,48)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"96.39" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>in_lock_funct=
ions (66,468,596 samples, 0.02%)</title><rect x=3D"1030.3" y=3D"1909" width=
=3D"0.2" height=3D"15.0" fill=3D"rgb(217,8,4)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"1033.29" y=3D"1919.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exi=
t (1,550,671,371 samples, 0.42%)</title><rect x=3D"142.3" y=3D"1845" width=
=3D"4.9" height=3D"15.0" fill=3D"rgb(214,220,46)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"145.27" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6=
,040,654,099 samples, 1.63%)</title><rect x=3D"10.0" y=3D"1365" width=3D"19=
.2" height=3D"15.0" fill=3D"rgb(205,3,43)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault =
(1,713,931,057 samples, 0.46%)</title><rect x=3D"74.2" y=3D"1653" width=3D"=
5.4" height=3D"15.0" fill=3D"rgb(238,177,8)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"77.18" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_=
interrupt (194,284,188 samples, 0.05%)</title><rect x=3D"111.3" y=3D"1509" =
width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,18,7)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"114.26" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>__x64_s=
ys_ioctl (1,356,735,820 samples, 0.37%)</title><rect x=3D"128.2" y=3D"1877"=
 width=3D"4.3" height=3D"15.0" fill=3D"rgb(227,220,33)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"131.19" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>get_us=
er_pages_unlocked (2,131,350,080 samples, 0.58%)</title><rect x=3D"112.9" y=
=3D"1701" width=3D"6.7" height=3D"15.0" fill=3D"rgb(245,108,43)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"115.86" y=3D"1711.5" ></text>=0A</g>=0A<g >=0A<tit=
le>send_call_function_single_ipi (266,171,345 samples, 0.07%)</title><rect =
x=3D"223.5" y=3D"1861" width=3D"0.9" height=3D"15.0" fill=3D"rgb(211,4,19)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"226.55" y=3D"1871.5" ></text>=0A</g>=0A=
<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D"10=
.0" y=3D"1621" width=3D"19.2" height=3D"15.0" fill=3D"rgb(206,66,24)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A=
<title>vmx_vcpu_load_vmcs (44,966,406 samples, 0.01%)</title><rect x=3D"171=
.9" y=3D"1589" width=3D"0.2" height=3D"15.0" fill=3D"rgb(253,178,10)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"174.93" y=3D"1599.5" ></text>=0A</g>=0A<g >=
=0A<title>entry_SYSCALL_64 (98,073,756 samples, 0.03%)</title><rect x=3D"11=
.8" y=3D"213" width=3D"0.3" height=3D"15.0" fill=3D"rgb(232,63,52)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"14.76" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>add_wait_queue (42,652,842,995 samples, 11.52%)</title><rect x=3D"1034.=
7" y=3D"1957" width=3D"135.9" height=3D"15.0" fill=3D"rgb(254,3,4)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"1037.75" y=3D"1967.5" >add_wait_queue</text>=0A=
</g>=0A<g >=0A<title>cpuacct_charge (524,890,104 samples, 0.14%)</title><re=
ct x=3D"751.3" y=3D"1637" width=3D"1.6" height=3D"15.0" fill=3D"rgb(234,136=
,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"754.27" y=3D"1647.5" ></text>=0A</=
g>=0A<g >=0A<title>do_syscall_64 (1,167,137,370 samples, 0.32%)</title><rec=
t x=3D"80.8" y=3D"1765" width=3D"3.7" height=3D"15.0" fill=3D"rgb(210,87,14=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.75" y=3D"1775.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_tdp_page_fault (1,550,671,371 samples, 0.42%)</title><=
rect x=3D"142.3" y=3D"1813" width=3D"4.9" height=3D"15.0" fill=3D"rgb(247,1=
26,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"145.27" y=3D"1823.5" ></text>=0A=
</g>=0A<g >=0A<title>__GI___ioctl (1,356,735,820 samples, 0.37%)</title><re=
ct x=3D"128.2" y=3D"1925" width=3D"4.3" height=3D"15.0" fill=3D"rgb(252,191=
,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1935.5" ></text>=0A</=
g>=0A<g >=0A<title>do_fault (1,381,981,405 samples, 0.37%)</title><rect x=
=3D"93.9" y=3D"1589" width=3D"4.4" height=3D"15.0" fill=3D"rgb(225,78,40)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"96.91" y=3D"1599.5" ></text>=0A</g>=0A<g=
 >=0A<title>kvm_tdp_page_fault (1,838,413,419 samples, 0.50%)</title><rect =
x=3D"184.2" y=3D"1893" width=3D"5.8" height=3D"15.0" fill=3D"rgb(253,52,25)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"187.15" y=3D"1903.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_handle_exit (2,032,317,152 samples, 0.55%)</title><rec=
t x=3D"172.4" y=3D"1909" width=3D"6.5" height=3D"15.0" fill=3D"rgb(229,71,1=
3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=3D"1919.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_vcpu_run (316,588,044 samples, 0.09%)</title><rect x=
=3D"79.6" y=3D"1669" width=3D"1.0" height=3D"15.0" fill=3D"rgb(234,155,23)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"82.64" y=3D"1679.5" ></text>=0A</g>=0A<=
g >=0A<title>__perf_event_task_sched_in (42,319,848 samples, 0.01%)</title>=
<rect x=3D"26.3" y=3D"69" width=3D"0.2" height=3D"15.0" fill=3D"rgb(218,221=
,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"29.33" y=3D"79.5" ></text>=0A</g>=
=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)</title><rect x=3D=
"10.0" y=3D"997" width=3D"19.2" height=3D"15.0" fill=3D"rgb(240,92,23)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1007.5" ></text>=0A</g>=0A<g >=
=0A<title>vmx_vcpu_pi_load (347,790,860 samples, 0.09%)</title><rect x=3D"7=
65.0" y=3D"1637" width=3D"1.1" height=3D"15.0" fill=3D"rgb(250,82,7)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"768.00" y=3D"1647.5" ></text>=0A</g>=0A<g >=
=0A<title>dequeue_entity (354,960,434 samples, 0.10%)</title><rect x=3D"170=
.8" y=3D"1621" width=3D"1.1" height=3D"15.0" fill=3D"rgb(212,28,12)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"173.79" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A=
<title>[unknown] (4,763,677,907 samples, 1.29%)</title><rect x=3D"10.0" y=
=3D"437" width=3D"15.2" height=3D"15.0" fill=3D"rgb(220,25,8)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>=
vcpu_enter_guest (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"=
373" width=3D"2.5" height=3D"15.0" fill=3D"rgb(253,68,33)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"29.48" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>vmx_h=
andle_exit (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"133" wi=
dth=3D"0.3" height=3D"15.0" fill=3D"rgb(226,177,22)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"15.08" y=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_sp=
in_lock (559,180,450 samples, 0.15%)</title><rect x=3D"75.0" y=3D"1413" wid=
th=3D"1.8" height=3D"15.0" fill=3D"rgb(231,40,24)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"78.05" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page=
_fault (2,137,312,641 samples, 0.58%)</title><rect x=3D"112.9" y=3D"1749" w=
idth=3D"6.8" height=3D"15.0" fill=3D"rgb(248,88,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"115.86" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_lock_irqsave (705,038,517 samples, 0.19%)</title><rect x=3D"33.4" y=3D"1=
317" width=3D"2.2" height=3D"15.0" fill=3D"rgb(205,114,19)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"36.38" y=3D"1327.5" ></text>=0A</g>=0A<g >=0A<title>x86=
_pmu_disable (236,517,943 samples, 0.06%)</title><rect x=3D"744.9" y=3D"166=
9" width=3D"0.8" height=3D"15.0" fill=3D"rgb(246,107,33)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"747.94" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>tick=
_sched_timer (80,050,831 samples, 0.02%)</title><rect x=3D"759.7" y=3D"1589=
" width=3D"0.3" height=3D"15.0" fill=3D"rgb(226,157,21)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"762.74" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>check=
_preemption_disabled (43,885,455 samples, 0.01%)</title><rect x=3D"455.4" y=
=3D"1941" width=3D"0.2" height=3D"15.0" fill=3D"rgb(207,100,17)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"458.42" y=3D"1951.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_release_page_clean (49,126,693 samples, 0.01%)</title><rect x=3D"31.=
5" y=3D"1493" width=3D"0.2" height=3D"15.0" fill=3D"rgb(227,223,38)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"34.54" y=3D"1503.5" ></text>=0A</g>=0A<g >=0A<=
title>do_fault (573,879,416 samples, 0.15%)</title><rect x=3D"128.9" y=3D"1=
669" width=3D"1.8" height=3D"15.0" fill=3D"rgb(244,18,51)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"131.89" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>kvm=
_mmu_page_fault (1,283,638,963 samples, 0.35%)</title><rect x=3D"49.8" y=3D=
"1589" width=3D"4.1" height=3D"15.0" fill=3D"rgb(218,123,14)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"52.76" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title=
>shmem_get_folio_gfp (1,161,432,362 samples, 0.31%)</title><rect x=3D"38.6"=
 y=3D"1381" width=3D"3.7" height=3D"15.0" fill=3D"rgb(237,32,14)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"41.55" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<tit=
le>kvm_arch_vcpu_ioctl_run (145,741,482 samples, 0.04%)</title><rect x=3D"2=
5.2" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(254,101,34)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"28.18" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<=
title>__do_fault (573,879,416 samples, 0.15%)</title><rect x=3D"128.9" y=3D=
"1653" width=3D"1.8" height=3D"15.0" fill=3D"rgb(219,86,48)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"131.89" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>k=
vm_release_page_clean (42,918,648 samples, 0.01%)</title><rect x=3D"189.9" =
y=3D"1877" width=3D"0.1" height=3D"15.0" fill=3D"rgb(213,3,20)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"192.87" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__gfn_to_hva_many (125,909,519 samples, 0.03%)</title><rect x=3D"467.6" y=
=3D"1861" width=3D"0.4" height=3D"15.0" fill=3D"rgb(215,78,32)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"470.58" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<titl=
e>kvm_mmu_notifier_invalidate_range_start (132,959,376 samples, 0.04%)</tit=
le><rect x=3D"1170.9" y=3D"1893" width=3D"0.4" height=3D"15.0" fill=3D"rgb(=
212,23,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1173.87" y=3D"1903.5" ></tex=
t>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (44,979,722 samples, 0.01%)</tit=
le><rect x=3D"130.5" y=3D"1589" width=3D"0.1" height=3D"15.0" fill=3D"rgb(2=
40,202,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.49" y=3D"1599.5" ></text=
>=0A</g>=0A<g >=0A<title>native_sched_clock (115,623,285 samples, 0.03%)</t=
itle><rect x=3D"775.8" y=3D"1653" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(225,110,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"778.81" y=3D"1663.5" ></tex=
t>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (1,041,244,058 samples, 0.28%)=
</title><rect x=3D"128.2" y=3D"1797" width=3D"3.3" height=3D"15.0" fill=3D"=
rgb(254,126,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"131.19" y=3D"1807.5" ></=
text>=0A</g>=0A<g >=0A<title>schedule (80,733,153 samples, 0.02%)</title><r=
ect x=3D"119.4" y=3D"1557" width=3D"0.2" height=3D"15.0" fill=3D"rgb(242,10=
5,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"122.39" y=3D"1567.5" ></text>=0A<=
/g>=0A<g >=0A<title>folio_activate (203,226,416 samples, 0.05%)</title><rec=
t x=3D"66.5" y=3D"1557" width=3D"0.6" height=3D"15.0" fill=3D"rgb(247,32,1)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"69.50" y=3D"1567.5" ></text>=0A</g>=0A=
<g >=0A<title>vmx_vcpu_pi_load (318,569,076 samples, 0.09%)</title><rect x=
=3D"105.0" y=3D"1445" width=3D"1.0" height=3D"15.0" fill=3D"rgb(233,89,40)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"108.03" y=3D"1455.5" ></text>=0A</g>=0A=
<g >=0A<title>__mod_lruvec_page_state (288,139,066 samples, 0.08%)</title><=
rect x=3D"1187.9" y=3D"1829" width=3D"0.9" height=3D"15.0" fill=3D"rgb(214,=
159,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1190.93" y=3D"1839.5" ></text>=
=0A</g>=0A<g >=0A<title>hrtimer_interrupt (199,463,518 samples, 0.05%)</tit=
le><rect x=3D"903.3" y=3D"1893" width=3D"0.7" height=3D"15.0" fill=3D"rgb(2=
30,208,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.33" y=3D"1903.5" ></text=
>=0A</g>=0A<g >=0A<title>syscall_trace_enter.isra.17 (66,462,510 samples, 0=
.02%)</title><rect x=3D"432.3" y=3D"1989" width=3D"0.2" height=3D"15.0" fil=
l=3D"rgb(250,87,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"435.31" y=3D"1999.5=
" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (129,467,492 samples, 0.03%)=
</title><rect x=3D"10.4" y=3D"165" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(253,204,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.39" y=3D"175.5" ></tex=
t>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (57,379,601 samples, 0.02%)</title><=
rect x=3D"112.7" y=3D"1765" width=3D"0.1" height=3D"15.0" fill=3D"rgb(215,1=
01,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.66" y=3D"1775.5" ></text>=0A=
</g>=0A<g >=0A<title>do_raw_read_unlock (281,473,741 samples, 0.08%)</title=
><rect x=3D"172.4" y=3D"1845" width=3D"0.9" height=3D"15.0" fill=3D"rgb(237=
,19,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=3D"1855.5" ></text>=
=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (133,987,142 samples, 0.04%)</title>=
<rect x=3D"16.8" y=3D"341" width=3D"0.4" height=3D"15.0" fill=3D"rgb(209,37=
,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"351.5" ></text>=0A</g>=
=0A<g >=0A<title>_raw_spin_lock_irqsave (760,098,764 samples, 0.21%)</title=
><rect x=3D"151.7" y=3D"1621" width=3D"2.4" height=3D"15.0" fill=3D"rgb(242=
,132,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"154.65" y=3D"1631.5" ></text>=
=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,091,339,808 samples, 0.29%)</t=
itle><rect x=3D"109.1" y=3D"1637" width=3D"3.5" height=3D"15.0" fill=3D"rgb=
(238,98,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"112.13" y=3D"1647.5" ></tex=
t>=0A</g>=0A<g >=0A<title>handle_mm_fault (2,131,350,080 samples, 0.58%)</t=
itle><rect x=3D"112.9" y=3D"1669" width=3D"6.7" height=3D"15.0" fill=3D"rgb=
(233,163,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.86" y=3D"1679.5" ></tex=
t>=0A</g>=0A<g >=0A<title>scheduler_tick (160,833,494 samples, 0.04%)</titl=
e><rect x=3D"834.2" y=3D"1781" width=3D"0.5" height=3D"15.0" fill=3D"rgb(21=
3,121,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"837.18" y=3D"1791.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (698,299,895 samples, 0.19%)</titl=
e><rect x=3D"38.6" y=3D"1317" width=3D"2.2" height=3D"15.0" fill=3D"rgb(223=
,169,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"41.60" y=3D"1327.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (123,051,561 samples, 0.03%)</title><=
rect x=3D"10.0" y=3D"101" width=3D"0.4" height=3D"15.0" fill=3D"rgb(235,114=
,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"111.5" ></text>=0A</g>=
=0A<g >=0A<title>entry_SYSCALL_64 (159,314,940 samples, 0.04%)</title><rect=
 x=3D"10.8" y=3D"165" width=3D"0.5" height=3D"15.0" fill=3D"rgb(242,206,40)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=3D"175.5" ></text>=0A</g>=0A<=
g >=0A<title>do_syscall_64 (3,063,052,576 samples, 0.83%)</title><rect x=3D=
"132.5" y=3D"1909" width=3D"9.8" height=3D"15.0" fill=3D"rgb(218,229,47)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"135.52" y=3D"1919.5" ></text>=0A</g>=0A<g=
 >=0A<title>schedule (210,342,010 samples, 0.06%)</title><rect x=3D"83.4" y=
=3D"1461" width=3D"0.7" height=3D"15.0" fill=3D"rgb(247,188,4)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"86.43" y=3D"1471.5" ></text>=0A</g>=0A<g >=0A<title=
>__mod_node_page_state (88,656,209 samples, 0.02%)</title><rect x=3D"1188.1=
" y=3D"1797" width=3D"0.3" height=3D"15.0" fill=3D"rgb(217,8,4)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1191.07" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__do_fault (1,373,790,402 samples, 0.37%)</title><rect x=3D"74.3" y=3D"=
1509" width=3D"4.4" height=3D"15.0" fill=3D"rgb(220,6,30)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"77.30" y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>kvm_=
tdp_page_fault (1,129,761,195 samples, 0.31%)</title><rect x=3D"80.8" y=3D"=
1653" width=3D"3.6" height=3D"15.0" fill=3D"rgb(220,132,36)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"83.82" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>na=
tive_queued_spin_lock_slowpath (59,246,463 samples, 0.02%)</title><rect x=
=3D"71.1" y=3D"1413" width=3D"0.2" height=3D"15.0" fill=3D"rgb(233,178,48)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"74.10" y=3D"1423.5" ></text>=0A</g>=0A<=
g >=0A<title>vcpu_enter_guest (2,549,679,159 samples, 0.69%)</title><rect x=
=3D"59.8" y=3D"1653" width=3D"8.1" height=3D"15.0" fill=3D"rgb(229,42,0)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"62.80" y=3D"1663.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_unlock (68,522,679 samples, 0.02%)</title><rect x=3D=
"13.4" y=3D"37" width=3D"0.2" height=3D"15.0" fill=3D"rgb(210,78,23)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"16.43" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<t=
itle>get_user_pages_unlocked (1,103,910,496 samples, 0.30%)</title><rect x=
=3D"50.3" y=3D"1525" width=3D"3.5" height=3D"15.0" fill=3D"rgb(214,12,48)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.27" y=3D"1535.5" ></text>=0A</g>=0A<g=
 >=0A<title>do_raw_spin_lock (431,481,042 samples, 0.12%)</title><rect x=3D=
"149.7" y=3D"1557" width=3D"1.3" height=3D"15.0" fill=3D"rgb(209,174,10)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"152.67" y=3D"1567.5" ></text>=0A</g>=0A<g=
 >=0A<title>clock_gettime@GLIBC_2.2.5 (67,898,795 samples, 0.02%)</title><r=
ect x=3D"1189.0" y=3D"2053" width=3D"0.2" height=3D"15.0" fill=3D"rgb(230,1=
80,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.98" y=3D"2063.5" ></text>=
=0A</g>=0A<g >=0A<title>do_syscall_64 (2,305,287,529 samples, 0.62%)</title=
><rect x=3D"42.4" y=3D"1669" width=3D"7.4" height=3D"15.0" fill=3D"rgb(221,=
107,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"45.41" y=3D"1679.5" ></text>=0A=
</g>=0A<g >=0A<title>native_write_msr (634,213,064 samples, 0.17%)</title><=
rect x=3D"872.9" y=3D"1925" width=3D"2.0" height=3D"15.0" fill=3D"rgb(254,9=
8,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"875.87" y=3D"1935.5" ></text>=0A<=
/g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (2,637,779,941 samples, 0.71%)<=
/title><rect x=3D"112.8" y=3D"1813" width=3D"8.4" height=3D"15.0" fill=3D"r=
gb(224,28,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.85" y=3D"1823.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (99,714,073 samples, 0.03%)</ti=
tle><rect x=3D"12.1" y=3D"197" width=3D"0.3" height=3D"15.0" fill=3D"rgb(21=
1,213,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"15.08" y=3D"207.5" ></text>=
=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,688,676,626 samples, 0.46%)</ti=
tle><rect x=3D"32.2" y=3D"1573" width=3D"5.4" height=3D"15.0" fill=3D"rgb(2=
36,33,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.23" y=3D"1583.5" ></text>=
=0A</g>=0A<g >=0A<title>rcu_note_context_switch (459,279,129 samples, 0.12%=
)</title><rect x=3D"867.9" y=3D"1909" width=3D"1.4" height=3D"15.0" fill=3D=
"rgb(205,197,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"870.86" y=3D"1919.5" >=
</text>=0A</g>=0A<g >=0A<title>update_process_times (194,284,188 samples, 0=
.05%)</title><rect x=3D"111.3" y=3D"1413" width=3D"0.6" height=3D"15.0" fil=
l=3D"rgb(218,162,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.26" y=3D"1423.=
5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (230,259,705 samples, 0.0=
6%)</title><rect x=3D"67.2" y=3D"1605" width=3D"0.7" height=3D"15.0" fill=
=3D"rgb(248,43,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"70.19" y=3D"1615.5" =
></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (3,104,413,288 samples, 0.=
84%)</title><rect x=3D"98.7" y=3D"1765" width=3D"9.9" height=3D"15.0" fill=
=3D"rgb(221,186,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.67" y=3D"1775.5=
" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (2,063,122,219 samples, =
0.56%)</title><rect x=3D"74.1" y=3D"1685" width=3D"6.5" height=3D"15.0" fil=
l=3D"rgb(228,200,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"77.08" y=3D"1695.5=
" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%)<=
/title><rect x=3D"10.0" y=3D"1285" width=3D"19.2" height=3D"15.0" fill=3D"r=
gb(254,190,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1295.5" ></t=
ext>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only (180,528,265 samples, =
0.05%)</title><rect x=3D"167.9" y=3D"1813" width=3D"0.6" height=3D"15.0" fi=
ll=3D"rgb(208,22,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.89" y=3D"1823.=
5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only (160,553,231 sa=
mples, 0.04%)</title><rect x=3D"49.8" y=3D"1525" width=3D"0.5" height=3D"15=
.0" fill=3D"rgb(211,2,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.76" y=3D"1=
535.5" ></text>=0A</g>=0A<g >=0A<title>ktime_get_update_offsets_now (44,326=
,053 samples, 0.01%)</title><rect x=3D"274.3" y=3D"1861" width=3D"0.2" heig=
ht=3D"15.0" fill=3D"rgb(222,71,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.=
34" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,274,652,040 =
samples, 0.34%)</title><rect x=3D"88.2" y=3D"1653" width=3D"4.1" height=3D"=
15.0" fill=3D"rgb(230,44,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.24" y=
=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (643,799,783 samples=
, 0.17%)</title><rect x=3D"29.5" y=3D"1381" width=3D"2.0" height=3D"15.0" f=
ill=3D"rgb(222,109,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.48" y=3D"1391=
.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (54,729,5=
82 samples, 0.01%)</title><rect x=3D"704.5" y=3D"1653" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(217,17,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.49=
" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (2,083,270,665 =
samples, 0.56%)</title><rect x=3D"172.4" y=3D"2021" width=3D"6.6" height=3D=
"15.0" fill=3D"rgb(212,97,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"175.40" y=
=3D"2031.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 sample=
s, 1.63%)</title><rect x=3D"10.0" y=3D"1557" width=3D"19.2" height=3D"15.0"=
 fill=3D"rgb(208,26,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"156=
7.5" ></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (132,97=
6,269 samples, 0.04%)</title><rect x=3D"1032.5" y=3D"1781" width=3D"0.4" he=
ight=3D"15.0" fill=3D"rgb(242,129,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"10=
35.50" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_lock (=
597,809,183 samples, 0.16%)</title><rect x=3D"74.9" y=3D"1445" width=3D"1.9=
" height=3D"15.0" fill=3D"rgb(244,186,32)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"77.92" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (=
132,964,444 samples, 0.04%)</title><rect x=3D"226.7" y=3D"1925" width=3D"0.=
4" height=3D"15.0" fill=3D"rgb(219,73,47)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"229.65" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A<title>userfaultfd_poll (=
43,979,665,226 samples, 11.87%)</title><rect x=3D"1030.5" y=3D"1973" width=
=3D"140.1" height=3D"15.0" fill=3D"rgb(211,72,18)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1033.52" y=3D"1983.5" >userfaultfd_poll</text>=0A</g>=0A<g >=0A<=
title>check_preemption_disabled (44,327,828 samples, 0.01%)</title><rect x=
=3D"1188.2" y=3D"1781" width=3D"0.2" height=3D"15.0" fill=3D"rgb(248,29,28)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1191.21" y=3D"1791.5" ></text>=0A</g>=
=0A<g >=0A<title>kvm_faultin_pfn (2,100,206,985 samples, 0.57%)</title><rec=
t x=3D"59.8" y=3D"1589" width=3D"6.7" height=3D"15.0" fill=3D"rgb(248,107,3=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.81" y=3D"1599.5" ></text>=0A</g>=
=0A<g >=0A<title>xas_descend (130,134,678 samples, 0.04%)</title><rect x=3D=
"42.9" y=3D"1349" width=3D"0.4" height=3D"15.0" fill=3D"rgb(238,63,32)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"45.86" y=3D"1359.5" ></text>=0A</g>=0A<g >=
=0A<title>shmem_fault (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" =
y=3D"165" width=3D"0.9" height=3D"15.0" fill=3D"rgb(245,87,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"28.64" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>=
handle_mm_fault (2,211,422,073 samples, 0.60%)</title><rect x=3D"99.6" y=3D=
"1637" width=3D"7.0" height=3D"15.0" fill=3D"rgb(215,27,44)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"102.56" y=3D"1647.5" ></text>=0A</g>=0A<g >=0A<title>i=
nternal_get_user_pages_fast (164,415,151 samples, 0.04%)</title><rect x=3D"=
184.2" y=3D"1829" width=3D"0.6" height=3D"15.0" fill=3D"rgb(249,208,9)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"187.23" y=3D"1839.5" ></text>=0A</g>=0A<g =
>=0A<title>entry_SYSCALL_64 (133,987,142 samples, 0.04%)</title><rect x=3D"=
16.8" y=3D"389" width=3D"0.4" height=3D"15.0" fill=3D"rgb(250,178,17)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"19.81" y=3D"399.5" ></text>=0A</g>=0A<g >=
=0A<title>task_numa_work (41,394,896 samples, 0.01%)</title><rect x=3D"875.=
4" y=3D"1925" width=3D"0.1" height=3D"15.0" fill=3D"rgb(236,135,44)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"878.39" y=3D"1935.5" ></text>=0A</g>=0A<g >=0A=
<title>kvm_vcpu_ioctl (1,655,662,953 samples, 0.45%)</title><rect x=3D"142.=
3" y=3D"1893" width=3D"5.2" height=3D"15.0" fill=3D"rgb(240,99,36)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"145.27" y=3D"1903.5" ></text>=0A</g>=0A<g >=0A<=
title>sysvec_apic_timer_interrupt (54,729,582 samples, 0.01%)</title><rect =
x=3D"704.5" y=3D"1669" width=3D"0.2" height=3D"15.0" fill=3D"rgb(223,176,25=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.49" y=3D"1679.5" ></text>=0A</g>=
=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (269,433,971 samples, 0.07=
%)</title><rect x=3D"262.3" y=3D"1957" width=3D"0.9" height=3D"15.0" fill=
=3D"rgb(238,73,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.31" y=3D"1967.5"=
 ></text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (66,501,182 samples, =
0.02%)</title><rect x=3D"274.1" y=3D"1781" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(230,145,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"277.06" y=3D"1791=
.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (66,487,499 samples, =
0.02%)</title><rect x=3D"273.2" y=3D"1925" width=3D"0.2" height=3D"15.0" fi=
ll=3D"rgb(226,115,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"276.20" y=3D"1935=
.5" ></text>=0A</g>=0A<g >=0A<title>newidle_balance (51,506,394 samples, 0.=
01%)</title><rect x=3D"96.9" y=3D"1461" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(242,190,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"99.86" y=3D"1471.5"=
 ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,111,133,729 samples, 0.=
30%)</title><rect x=3D"13.3" y=3D"277" width=3D"3.5" height=3D"15.0" fill=
=3D"rgb(214,162,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"287.5" =
></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,046,597,074 samples, 0.28%)</=
title><rect x=3D"84.6" y=3D"1637" width=3D"3.3" height=3D"15.0" fill=3D"rgb=
(243,48,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.58" y=3D"1647.5" ></text=
>=0A</g>=0A<g >=0A<title>schedule (223,371,606 samples, 0.06%)</title><rect=
 x=3D"146.3" y=3D"1621" width=3D"0.7" height=3D"15.0" fill=3D"rgb(242,148,2=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"149.28" y=3D"1631.5" ></text>=0A</g>=
=0A<g >=0A<title>__kvm_mmu_topup_memory_cache (52,812,083 samples, 0.01%)</=
title><rect x=3D"462.7" y=3D"1893" width=3D"0.2" height=3D"15.0" fill=3D"rg=
b(226,223,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"465.75" y=3D"1903.5" ></t=
ext>=0A</g>=0A<g >=0A<title>vmx_handle_exit (1,120,566,227 samples, 0.30%)<=
/title><rect x=3D"32.9" y=3D"1557" width=3D"3.6" height=3D"15.0" fill=3D"rg=
b(236,215,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.92" y=3D"1567.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (1,539,194,524 samples, 0.42%)</t=
itle><rect x=3D"167.5" y=3D"1941" width=3D"4.9" height=3D"15.0" fill=3D"rgb=
(238,213,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.50" y=3D"1951.5" ></tex=
t>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,111,133,729 samples, 0.30%)</t=
itle><rect x=3D"13.3" y=3D"165" width=3D"3.5" height=3D"15.0" fill=3D"rgb(2=
07,205,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"175.5" ></text>=
=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (1,368,870,939 samples, 0.3=
7%)</title><rect x=3D"68.7" y=3D"1573" width=3D"4.4" height=3D"15.0" fill=
=3D"rgb(241,52,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"71.70" y=3D"1583.5" =
></text>=0A</g>=0A<g >=0A<title>folio_batch_move_lru (309,327,693 samples, =
0.08%)</title><rect x=3D"156.3" y=3D"1765" width=3D"1.0" height=3D"15.0" fi=
ll=3D"rgb(212,22,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"159.29" y=3D"1775.=
5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (10,806=
,687,973 samples, 2.92%)</title><rect x=3D"707.3" y=3D"1701" width=3D"34.5"=
 height=3D"15.0" fill=3D"rgb(213,148,22)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"710.34" y=3D"1711.5" >na..</text>=0A</g>=0A<g >=0A<title>follow_page_ma=
sk (728,298,511 samples, 0.20%)</title><rect x=3D"487.1" y=3D"1829" width=
=3D"2.3" height=3D"15.0" fill=3D"rgb(247,149,9)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"490.11" y=3D"1839.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_com=
mon_lock (1,103,520,998 samples, 0.30%)</title><rect x=3D"62.2" y=3D"1413" =
width=3D"3.5" height=3D"15.0" fill=3D"rgb(214,205,8)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"65.18" y=3D"1423.5" ></text>=0A</g>=0A<g >=0A<title>__filema=
p_get_folio (176,248,668 samples, 0.05%)</title><rect x=3D"148.6" y=3D"1653=
" width=3D"0.5" height=3D"15.0" fill=3D"rgb(219,170,14)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"151.58" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>_raw_=
spin_unlock (287,200,176 samples, 0.08%)</title><rect x=3D"491.0" y=3D"1813=
" width=3D"0.9" height=3D"15.0" fill=3D"rgb(230,164,48)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"494.02" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>__get=
_user_pages (1,479,547,035 samples, 0.40%)</title><rect x=3D"142.3" y=3D"17=
49" width=3D"4.7" height=3D"15.0" fill=3D"rgb(247,127,34)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"145.27" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>rew=
eight_entity (205,999,155 samples, 0.06%)</title><rect x=3D"748.2" y=3D"165=
3" width=3D"0.6" height=3D"15.0" fill=3D"rgb(251,199,9)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"751.17" y=3D"1663.5" ></text>=0A</g>=0A<g >=0A<title>__GI_=
__ioctl (264,013,792 samples, 0.07%)</title><rect x=3D"25.6" y=3D"453" widt=
h=3D"0.9" height=3D"15.0" fill=3D"rgb(234,102,20)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"28.64" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_fol=
io_gfp (1,236,031,354 samples, 0.33%)</title><rect x=3D"88.4" y=3D"1525" wi=
dth=3D"3.9" height=3D"15.0" fill=3D"rgb(233,37,20)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"91.36" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release=
_page_clean (282,804,178 samples, 0.08%)</title><rect x=3D"127.1" y=3D"1749=
" width=3D"0.9" height=3D"15.0" fill=3D"rgb(233,35,33)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"130.07" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>shmem_=
fault (2,131,350,080 samples, 0.58%)</title><rect x=3D"112.9" y=3D"1605" wi=
dth=3D"6.7" height=3D"15.0" fill=3D"rgb(206,172,22)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"115.86" y=3D"1615.5" ></text>=0A</g>=0A<g >=0A<title>fput (6=
32,036,265 samples, 0.17%)</title><rect x=3D"182.1" y=3D"1973" width=3D"2.0=
" height=3D"15.0" fill=3D"rgb(211,224,5)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"185.11" y=3D"1983.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,513,=
316,000 samples, 0.41%)</title><rect x=3D"68.2" y=3D"1589" width=3D"4.9" he=
ight=3D"15.0" fill=3D"rgb(227,121,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
1.24" y=3D"1599.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (57,379,6=
01 samples, 0.02%)</title><rect x=3D"112.7" y=3D"1749" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(229,191,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"115.6=
6" y=3D"1759.5" ></text>=0A</g>=0A<g >=0A<title>__do_fault (61,757,117 samp=
les, 0.02%)</title><rect x=3D"29.0" y=3D"213" width=3D"0.2" height=3D"15.0"=
 fill=3D"rgb(214,12,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.00" y=3D"223.=
5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,064,009,009 samples, =
0.29%)</title><rect x=3D"50.4" y=3D"1493" width=3D"3.4" height=3D"15.0" fil=
l=3D"rgb(237,0,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"53.40" y=3D"1503.5" =
></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (194,284,188=
 samples, 0.05%)</title><rect x=3D"111.3" y=3D"1365" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(218,180,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"114.2=
6" y=3D"1375.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_fault (1,191,610,=
370 samples, 0.32%)</title><rect x=3D"55.0" y=3D"1509" width=3D"3.8" height=
=3D"15.0" fill=3D"rgb(224,40,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"58.02"=
 y=3D"1519.5" ></text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (3,113,169,=
578 samples, 0.84%)</title><rect x=3D"745.7" y=3D"1685" width=3D"9.9" heigh=
t=3D"15.0" fill=3D"rgb(223,4,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"748.70=
" y=3D"1695.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (53,059,884,627 sa=
mples, 14.33%)</title><rect x=3D"10.0" y=3D"2037" width=3D"169.0" height=3D=
"15.0" fill=3D"rgb(247,184,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=
=3D"2047.5" >[unknown]</text>=0A</g>=0A<g >=0A<title>check_preemption_disab=
led (44,162,238 samples, 0.01%)</title><rect x=3D"1175.6" y=3D"1797" width=
=3D"0.1" height=3D"15.0" fill=3D"rgb(236,133,51)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1178.55" y=3D"1807.5" ></text>=0A</g>=0A<g >=0A<title>kvm_is_mmio=
_pfn (109,477,458 samples, 0.03%)</title><rect x=3D"815.9" y=3D"1861" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(222,20,9)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"818.92" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_=
ioctl_run (3,104,413,288 samples, 0.84%)</title><rect x=3D"98.7" y=3D"1781"=
 width=3D"9.9" height=3D"15.0" fill=3D"rgb(248,55,15)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"101.67" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>get_use=
r_pages_unlocked (99,714,073 samples, 0.03%)</title><rect x=3D"12.1" y=3D"5=
3" width=3D"0.3" height=3D"15.0" fill=3D"rgb(223,209,29)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"15.08" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu=
_page_fault (1,468,270,705 samples, 0.40%)</title><rect x=3D"37.7" y=3D"155=
7" width=3D"4.6" height=3D"15.0" fill=3D"rgb(237,111,26)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"40.67" y=3D"1567.5" ></text>=0A</g>=0A<g >=0A<title>do_sy=
scall_64 (911,547,376 samples, 0.25%)</title><rect x=3D"29.2" y=3D"1621" wi=
dth=3D"2.9" height=3D"15.0" fill=3D"rgb(206,22,16)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"32.24" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault=
 (1,523,136,454 samples, 0.41%)</title><rect x=3D"122.2" y=3D"1621" width=
=3D"4.9" height=3D"15.0" fill=3D"rgb(227,51,27)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"125.22" y=3D"1631.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_u=
nlock (194,252,933 samples, 0.05%)</title><rect x=3D"83.5" y=3D"1381" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(244,49,35)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"86.48" y=3D"1391.5" ></text>=0A</g>=0A<g >=0A<title>handle_mm_faul=
t (790,301,371 samples, 0.21%)</title><rect x=3D"26.5" y=3D"245" width=3D"2=
.5" height=3D"15.0" fill=3D"rgb(254,219,19)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"29.48" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>smp_call_function_s=
ingle (402,390,541 samples, 0.11%)</title><rect x=3D"26.5" y=3D"37" width=
=3D"1.3" height=3D"15.0" fill=3D"rgb(248,217,15)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"29.49" y=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock=
 (219,093,086 samples, 0.06%)</title><rect x=3D"782.0" y=3D"1525" width=3D"=
0.7" height=3D"15.0" fill=3D"rgb(252,43,46)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"784.97" y=3D"1535.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt=
 (160,833,494 samples, 0.04%)</title><rect x=3D"834.2" y=3D"1861" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(217,82,23)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"837.18" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>down_read_killabl=
e (695,677,890 samples, 0.19%)</title><rect x=3D"785.9" y=3D"1845" width=3D=
"2.2" height=3D"15.0" fill=3D"rgb(219,214,22)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"788.89" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl =
(61,757,117 samples, 0.02%)</title><rect x=3D"29.0" y=3D"421" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(231,194,49)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"32.00" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__mod_zone_page_stat=
e (66,092,699 samples, 0.02%)</title><rect x=3D"1175.8" y=3D"1813" width=3D=
"0.2" height=3D"15.0" fill=3D"rgb(232,175,25)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"1178.76" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>sched_clock_cp=
u (120,236,452 samples, 0.03%)</title><rect x=3D"780.8" y=3D"1669" width=3D=
"0.4" height=3D"15.0" fill=3D"rgb(231,133,10)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"783.85" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (1,7=
24,589,751 samples, 0.47%)</title><rect x=3D"173.3" y=3D"1845" width=3D"5.5=
" height=3D"15.0" fill=3D"rgb(248,207,16)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"176.30" y=3D"1855.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (=
1,167,137,370 samples, 0.32%)</title><rect x=3D"80.8" y=3D"1781" width=3D"3=
.7" height=3D"15.0" fill=3D"rgb(238,46,27)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"83.75" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault (1,167,=
219,750 samples, 0.32%)</title><rect x=3D"55.1" y=3D"1445" width=3D"3.7" he=
ight=3D"15.0" fill=3D"rgb(234,131,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"5=
8.10" y=3D"1455.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (1,931,806,=
377 samples, 0.52%)</title><rect x=3D"67.9" y=3D"1765" width=3D"6.2" height=
=3D"15.0" fill=3D"rgb(230,39,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"70.92"=
 y=3D"1775.5" ></text>=0A</g>=0A<g >=0A<title>kvm_can_do_async_pf (299,240,=
479 samples, 0.08%)</title><rect x=3D"793.6" y=3D"1877" width=3D"0.9" heigh=
t=3D"15.0" fill=3D"rgb(251,53,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"796.5=
8" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (2,719,092,=
456 samples, 0.73%)</title><rect x=3D"147.6" y=3D"1813" width=3D"8.7" heigh=
t=3D"15.0" fill=3D"rgb(212,131,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"150.=
63" y=3D"1823.5" ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (159,314,94=
0 samples, 0.04%)</title><rect x=3D"10.8" y=3D"37" width=3D"0.5" height=3D"=
15.0" fill=3D"rgb(249,133,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.80" y=
=3D"47.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath =
(503,613,302 samples, 0.14%)</title><rect x=3D"177.0" y=3D"1669" width=3D"1=
.7" height=3D"15.0" fill=3D"rgb(235,114,21)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"180.05" y=3D"1679.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_ir=
qsave (698,299,895 samples, 0.19%)</title><rect x=3D"38.6" y=3D"1333" width=
=3D"2.2" height=3D"15.0" fill=3D"rgb(246,152,42)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"41.60" y=3D"1343.5" ></text>=0A</g>=0A<g >=0A<title>folio_activat=
e (309,327,693 samples, 0.08%)</title><rect x=3D"156.3" y=3D"1781" width=3D=
"1.0" height=3D"15.0" fill=3D"rgb(211,199,4)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"159.29" y=3D"1791.5" ></text>=0A</g>=0A<g >=0A<title>schedule (304,12=
0,856 samples, 0.08%)</title><rect x=3D"71.3" y=3D"1429" width=3D"1.0" heig=
ht=3D"15.0" fill=3D"rgb(244,196,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"74.=
29" y=3D"1439.5" ></text>=0A</g>=0A<g >=0A<title>__audit_syscall_exit (66,4=
67,170 samples, 0.02%)</title><rect x=3D"252.2" y=3D"1957" width=3D"0.2" he=
ight=3D"15.0" fill=3D"rgb(219,214,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"2=
55.15" y=3D"1967.5" ></text>=0A</g>=0A<g >=0A<title>release_pages (329,291,=
450 samples, 0.09%)</title><rect x=3D"1183.8" y=3D"1877" width=3D"1.1" heig=
ht=3D"15.0" fill=3D"rgb(221,29,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1186=
.83" y=3D"1887.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (177,285=
,076 samples, 0.05%)</title><rect x=3D"903.3" y=3D"1861" width=3D"0.6" heig=
ht=3D"15.0" fill=3D"rgb(224,5,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.3=
3" y=3D"1871.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (264,013,79=
2 samples, 0.07%)</title><rect x=3D"25.6" y=3D"405" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(222,215,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"28.64" y=
=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>_raw_read_lock (44,165,953 sampl=
es, 0.01%)</title><rect x=3D"462.9" y=3D"1893" width=3D"0.2" height=3D"15.0=
" fill=3D"rgb(208,163,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"465.91" y=3D"=
1903.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (617,505,546 samples, 0.=
17%)</title><rect x=3D"138.3" y=3D"1589" width=3D"2.0" height=3D"15.0" fill=
=3D"rgb(240,128,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"141.34" y=3D"1599.5=
" ></text>=0A</g>=0A<g >=0A<title>kvm_faultin_pfn (1,274,652,040 samples, 0=
.34%)</title><rect x=3D"88.2" y=3D"1669" width=3D"4.1" height=3D"15.0" fill=
=3D"rgb(229,63,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.24" y=3D"1679.5" =
></text>=0A</g>=0A<g >=0A<title>__handle_mm_fault (1,111,133,729 samples, 0=
.30%)</title><rect x=3D"13.3" y=3D"149" width=3D"3.5" height=3D"15.0" fill=
=3D"rgb(214,210,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"16.27" y=3D"159.5" =
></text>=0A</g>=0A<g >=0A<title>get_user_pages_unlocked (2,491,551,090 samp=
les, 0.67%)</title><rect x=3D"17.2" y=3D"229" width=3D"8.0" height=3D"15.0"=
 fill=3D"rgb(239,24,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.24" y=3D"239=
.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (6,040,654,099 samples, 1.63%=
)</title><rect x=3D"10.0" y=3D"1477" width=3D"19.2" height=3D"15.0" fill=3D=
"rgb(239,30,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1487.5" ></=
text>=0A</g>=0A<g >=0A<title>shmem_get_folio (1,322,294,841 samples, 0.36%)=
</title><rect x=3D"890.6" y=3D"1957" width=3D"4.2" height=3D"15.0" fill=3D"=
rgb(245,9,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"893.60" y=3D"1967.5" ></te=
xt>=0A</g>=0A<g >=0A<title>[unknown] (13,797,449,489 samples, 3.73%)</title=
><rect x=3D"10.0" y=3D"1733" width=3D"44.0" height=3D"15.0" fill=3D"rgb(237=
,117,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"1743.5" >[unk..</t=
ext>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (3,063,052,576 samples, 0.83%)</=
title><rect x=3D"132.5" y=3D"1877" width=3D"9.8" height=3D"15.0" fill=3D"rg=
b(241,102,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"135.52" y=3D"1887.5" ></t=
ext>=0A</g>=0A<g >=0A<title>do_fault (643,799,783 samples, 0.17%)</title><r=
ect x=3D"29.5" y=3D"1397" width=3D"2.0" height=3D"15.0" fill=3D"rgb(224,211=
,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.48" y=3D"1407.5" ></text>=0A</g=
>=0A<g >=0A<title>native_queued_spin_lock_slowpath (129,373,983 samples, 0.=
03%)</title><rect x=3D"126.5" y=3D"1557" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(218,174,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"129.52" y=3D"1567.5=
" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (886,667,938 samples, 0.=
24%)</title><rect x=3D"436.0" y=3D"2021" width=3D"2.8" height=3D"15.0" fill=
=3D"rgb(223,220,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"439.02" y=3D"2031.5=
" ></text>=0A</g>=0A<g >=0A<title>vcpu_enter_guest (1,167,137,370 samples, =
0.32%)</title><rect x=3D"80.8" y=3D"1701" width=3D"3.7" height=3D"15.0" fil=
l=3D"rgb(227,28,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"83.75" y=3D"1711.5"=
 ></text>=0A</g>=0A<g >=0A<title>schedule (313,725,446 samples, 0.08%)</tit=
le><rect x=3D"41.2" y=3D"1349" width=3D"1.0" height=3D"15.0" fill=3D"rgb(23=
7,161,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"44.21" y=3D"1359.5" ></text>=
=0A</g>=0A</g>=0A</svg>=0A
--Mh1nfu5EYGrCe8FI
Content-Type: image/svg+xml
Content-Disposition: attachment; filename="uffd-32-reader-32.svg"
Content-Transfer-Encoding: quoted-printable

<?xml version=3D"1.0" standalone=3D"no"?>=0A<!DOCTYPE svg PUBLIC "-//W3C//D=
TD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">=0A<svg =
version=3D"1.1" width=3D"1200" height=3D"774" onload=3D"init(evt)" viewBox=
=3D"0 0 1200 774" xmlns=3D"http://www.w3.org/2000/svg" xmlns:xlink=3D"http:=
//www.w3.org/1999/xlink">=0A<!-- Flame graph stack visualization. See https=
://github.com/brendangregg/FlameGraph for latest version, and http://www.br=
endangregg.com/flamegraphs.html for examples. -->=0A<!-- NOTES:  -->=0A<def=
s>=0A=09<linearGradient id=3D"background" y1=3D"0" y2=3D"1" x1=3D"0" x2=3D"=
0" >=0A=09=09<stop stop-color=3D"#eeeeee" offset=3D"5%" />=0A=09=09<stop st=
op-color=3D"#eeeeb0" offset=3D"95%" />=0A=09</linearGradient>=0A</defs>=0A<=
style type=3D"text/css">=0A=09text { font-family:Verdana; font-size:12px; f=
ill:rgb(0,0,0); }=0A=09#search, #ignorecase { opacity:0.1; cursor:pointer; =
}=0A=09#search:hover, #search.show, #ignorecase:hover, #ignorecase.show { o=
pacity:1; }=0A=09#subtitle { text-anchor:middle; font-color:rgb(160,160,160=
); }=0A=09#title { text-anchor:middle; font-size:17px}=0A=09#unzoom { curso=
r:pointer; }=0A=09#frames > *:hover { stroke:black; stroke-width:0.5; curso=
r:pointer; }=0A=09.hide { display:none; }=0A=09.parent { opacity:0.5; }=0A<=
/style>=0A<script type=3D"text/ecmascript">=0A<![CDATA[=0A=09"use strict";=
=0A=09var details, searchbtn, unzoombtn, matchedtxt, svg, searching, curren=
tSearchTerm, ignorecase, ignorecaseBtn;=0A=09function init(evt) {=0A=09=09d=
etails =3D document.getElementById("details").firstChild;=0A=09=09searchbtn=
 =3D document.getElementById("search");=0A=09=09ignorecaseBtn =3D document.=
getElementById("ignorecase");=0A=09=09unzoombtn =3D document.getElementById=
("unzoom");=0A=09=09matchedtxt =3D document.getElementById("matched");=0A=
=09=09svg =3D document.getElementsByTagName("svg")[0];=0A=09=09searching =
=3D 0;=0A=09=09currentSearchTerm =3D null;=0A=0A=09=09// use GET parameters=
 to restore a flamegraphs state.=0A=09=09var params =3D get_params();=0A=09=
=09if (params.x && params.y)=0A=09=09=09zoom(find_group(document.querySelec=
tor('[x=3D"' + params.x + '"][y=3D"' + params.y + '"]')));=0A              =
  if (params.s) search(params.s);=0A=09}=0A=0A=09// event listeners=0A=09wi=
ndow.addEventListener("click", function(e) {=0A=09=09var target =3D find_gr=
oup(e.target);=0A=09=09if (target) {=0A=09=09=09if (target.nodeName =3D=3D =
"a") {=0A=09=09=09=09if (e.ctrlKey =3D=3D=3D false) return;=0A=09=09=09=09e=
.preventDefault();=0A=09=09=09}=0A=09=09=09if (target.classList.contains("p=
arent")) unzoom(true);=0A=09=09=09zoom(target);=0A=09=09=09if (!document.qu=
erySelector('.parent')) {=0A=09=09=09=09// we have basically done a clearzo=
om so clear the url=0A=09=09=09=09var params =3D get_params();=0A=09=09=09=
=09if (params.x) delete params.x;=0A=09=09=09=09if (params.y) delete params=
.y;=0A=09=09=09=09history.replaceState(null, null, parse_params(params));=
=0A=09=09=09=09unzoombtn.classList.add("hide");=0A=09=09=09=09return;=0A=09=
=09=09}=0A=0A=09=09=09// set parameters for zoom state=0A=09=09=09var el =
=3D target.querySelector("rect");=0A=09=09=09if (el && el.attributes && el.=
attributes.y && el.attributes._orig_x) {=0A=09=09=09=09var params =3D get_p=
arams()=0A=09=09=09=09params.x =3D el.attributes._orig_x.value;=0A=09=09=09=
=09params.y =3D el.attributes.y.value;=0A=09=09=09=09history.replaceState(n=
ull, null, parse_params(params));=0A=09=09=09}=0A=09=09}=0A=09=09else if (e=
.target.id =3D=3D "unzoom") clearzoom();=0A=09=09else if (e.target.id =3D=
=3D "search") search_prompt();=0A=09=09else if (e.target.id =3D=3D "ignorec=
ase") toggle_ignorecase();=0A=09}, false)=0A=0A=09// mouse-over for info=0A=
=09// show=0A=09window.addEventListener("mouseover", function(e) {=0A=09=09=
var target =3D find_group(e.target);=0A=09=09if (target) details.nodeValue =
=3D "Function: " + g_to_text(target);=0A=09}, false)=0A=0A=09// clear=0A=09=
window.addEventListener("mouseout", function(e) {=0A=09=09var target =3D fi=
nd_group(e.target);=0A=09=09if (target) details.nodeValue =3D ' ';=0A=09}, =
false)=0A=0A=09// ctrl-F for search=0A=09// ctrl-I to toggle case-sensitive=
 search=0A=09window.addEventListener("keydown",function (e) {=0A=09=09if (e=
.keyCode =3D=3D=3D 114 || (e.ctrlKey && e.keyCode =3D=3D=3D 70)) {=0A=09=09=
=09e.preventDefault();=0A=09=09=09search_prompt();=0A=09=09}=0A=09=09else i=
f (e.ctrlKey && e.keyCode =3D=3D=3D 73) {=0A=09=09=09e.preventDefault();=0A=
=09=09=09toggle_ignorecase();=0A=09=09}=0A=09}, false)=0A=0A=09// functions=
=0A=09function get_params() {=0A=09=09var params =3D {};=0A=09=09var params=
arr =3D window.location.search.substr(1).split('&');=0A=09=09for (var i =3D=
 0; i < paramsarr.length; ++i) {=0A=09=09=09var tmp =3D paramsarr[i].split(=
"=3D");=0A=09=09=09if (!tmp[0] || !tmp[1]) continue;=0A=09=09=09params[tmp[=
0]]  =3D decodeURIComponent(tmp[1]);=0A=09=09}=0A=09=09return params;=0A=09=
}=0A=09function parse_params(params) {=0A=09=09var uri =3D "?";=0A=09=09for=
 (var key in params) {=0A=09=09=09uri +=3D key + '=3D' + encodeURIComponent=
(params[key]) + '&';=0A=09=09}=0A=09=09if (uri.slice(-1) =3D=3D "&")=0A=09=
=09=09uri =3D uri.substring(0, uri.length - 1);=0A=09=09if (uri =3D=3D '?')=
=0A=09=09=09uri =3D window.location.href.split('?')[0];=0A=09=09return uri;=
=0A=09}=0A=09function find_child(node, selector) {=0A=09=09var children =3D=
 node.querySelectorAll(selector);=0A=09=09if (children.length) return child=
ren[0];=0A=09}=0A=09function find_group(node) {=0A=09=09var parent =3D node=
.parentElement;=0A=09=09if (!parent) return;=0A=09=09if (parent.id =3D=3D "=
frames") return node;=0A=09=09return find_group(parent);=0A=09}=0A=09functi=
on orig_save(e, attr, val) {=0A=09=09if (e.attributes["_orig_" + attr] !=3D=
 undefined) return;=0A=09=09if (e.attributes[attr] =3D=3D undefined) return=
;=0A=09=09if (val =3D=3D undefined) val =3D e.attributes[attr].value;=0A=09=
=09e.setAttribute("_orig_" + attr, val);=0A=09}=0A=09function orig_load(e, =
attr) {=0A=09=09if (e.attributes["_orig_"+attr] =3D=3D undefined) return;=
=0A=09=09e.attributes[attr].value =3D e.attributes["_orig_" + attr].value;=
=0A=09=09e.removeAttribute("_orig_"+attr);=0A=09}=0A=09function g_to_text(e=
) {=0A=09=09var text =3D find_child(e, "title").firstChild.nodeValue;=0A=09=
=09return (text)=0A=09}=0A=09function g_to_func(e) {=0A=09=09var func =3D g=
_to_text(e);=0A=09=09// if there's any manipulation we want to do to the fu=
nction=0A=09=09// name before it's searched, do it here before returning.=
=0A=09=09return (func);=0A=09}=0A=09function update_text(e) {=0A=09=09var r=
 =3D find_child(e, "rect");=0A=09=09var t =3D find_child(e, "text");=0A=09=
=09var w =3D parseFloat(r.attributes.width.value) -3;=0A=09=09var txt =3D f=
ind_child(e, "title").textContent.replace(/\([^(]*\)$/,"");=0A=09=09t.attri=
butes.x.value =3D parseFloat(r.attributes.x.value) + 3;=0A=0A=09=09// Small=
er than this size won't fit anything=0A=09=09if (w < 2 * 12 * 0.59) {=0A=09=
=09=09t.textContent =3D "";=0A=09=09=09return;=0A=09=09}=0A=0A=09=09t.textC=
ontent =3D txt;=0A=09=09var sl =3D t.getSubStringLength(0, txt.length);=0A=
=09=09// check if only whitespace or if we can fit the entire string into w=
idth w=0A=09=09if (/^ *$/.test(txt) || sl < w)=0A=09=09=09return;=0A=0A=09=
=09// this isn't perfect, but gives a good starting point=0A=09=09// and av=
oids calling getSubStringLength too often=0A=09=09var start =3D Math.floor(=
(w/sl) * txt.length);=0A=09=09for (var x =3D start; x > 0; x =3D x-2) {=0A=
=09=09=09if (t.getSubStringLength(0, x + 2) <=3D w) {=0A=09=09=09=09t.textC=
ontent =3D txt.substring(0, x) + "..";=0A=09=09=09=09return;=0A=09=09=09}=
=0A=09=09}=0A=09=09t.textContent =3D "";=0A=09}=0A=0A=09// zoom=0A=09functi=
on zoom_reset(e) {=0A=09=09if (e.attributes !=3D undefined) {=0A=09=09=09or=
ig_load(e, "x");=0A=09=09=09orig_load(e, "width");=0A=09=09}=0A=09=09if (e.=
childNodes =3D=3D undefined) return;=0A=09=09for (var i =3D 0, c =3D e.chil=
dNodes; i < c.length; i++) {=0A=09=09=09zoom_reset(c[i]);=0A=09=09}=0A=09}=
=0A=09function zoom_child(e, x, ratio) {=0A=09=09if (e.attributes !=3D unde=
fined) {=0A=09=09=09if (e.attributes.x !=3D undefined) {=0A=09=09=09=09orig=
_save(e, "x");=0A=09=09=09=09e.attributes.x.value =3D (parseFloat(e.attribu=
tes.x.value) - x - 10) * ratio + 10;=0A=09=09=09=09if (e.tagName =3D=3D "te=
xt")=0A=09=09=09=09=09e.attributes.x.value =3D find_child(e.parentNode, "re=
ct[x]").attributes.x.value + 3;=0A=09=09=09}=0A=09=09=09if (e.attributes.wi=
dth !=3D undefined) {=0A=09=09=09=09orig_save(e, "width");=0A=09=09=09=09e.=
attributes.width.value =3D parseFloat(e.attributes.width.value) * ratio;=0A=
=09=09=09}=0A=09=09}=0A=0A=09=09if (e.childNodes =3D=3D undefined) return;=
=0A=09=09for (var i =3D 0, c =3D e.childNodes; i < c.length; i++) {=0A=09=
=09=09zoom_child(c[i], x - 10, ratio);=0A=09=09}=0A=09}=0A=09function zoom_=
parent(e) {=0A=09=09if (e.attributes) {=0A=09=09=09if (e.attributes.x !=3D =
undefined) {=0A=09=09=09=09orig_save(e, "x");=0A=09=09=09=09e.attributes.x.=
value =3D 10;=0A=09=09=09}=0A=09=09=09if (e.attributes.width !=3D undefined=
) {=0A=09=09=09=09orig_save(e, "width");=0A=09=09=09=09e.attributes.width.v=
alue =3D parseInt(svg.width.baseVal.value) - (10 * 2);=0A=09=09=09}=0A=09=
=09}=0A=09=09if (e.childNodes =3D=3D undefined) return;=0A=09=09for (var i =
=3D 0, c =3D e.childNodes; i < c.length; i++) {=0A=09=09=09zoom_parent(c[i]=
);=0A=09=09}=0A=09}=0A=09function zoom(node) {=0A=09=09var attr =3D find_ch=
ild(node, "rect").attributes;=0A=09=09var width =3D parseFloat(attr.width.v=
alue);=0A=09=09var xmin =3D parseFloat(attr.x.value);=0A=09=09var xmax =3D =
parseFloat(xmin + width);=0A=09=09var ymin =3D parseFloat(attr.y.value);=0A=
=09=09var ratio =3D (svg.width.baseVal.value - 2 * 10) / width;=0A=0A=09=09=
// XXX: Workaround for JavaScript float issues (fix me)=0A=09=09var fudge =
=3D 0.0001;=0A=0A=09=09unzoombtn.classList.remove("hide");=0A=0A=09=09var e=
l =3D document.getElementById("frames").children;=0A=09=09for (var i =3D 0;=
 i < el.length; i++) {=0A=09=09=09var e =3D el[i];=0A=09=09=09var a =3D fin=
d_child(e, "rect").attributes;=0A=09=09=09var ex =3D parseFloat(a.x.value);=
=0A=09=09=09var ew =3D parseFloat(a.width.value);=0A=09=09=09var upstack;=
=0A=09=09=09// Is it an ancestor=0A=09=09=09if (0 =3D=3D 0) {=0A=09=09=09=
=09upstack =3D parseFloat(a.y.value) > ymin;=0A=09=09=09} else {=0A=09=09=
=09=09upstack =3D parseFloat(a.y.value) < ymin;=0A=09=09=09}=0A=09=09=09if =
(upstack) {=0A=09=09=09=09// Direct ancestor=0A=09=09=09=09if (ex <=3D xmin=
 && (ex+ew+fudge) >=3D xmax) {=0A=09=09=09=09=09e.classList.add("parent");=
=0A=09=09=09=09=09zoom_parent(e);=0A=09=09=09=09=09update_text(e);=0A=09=09=
=09=09}=0A=09=09=09=09// not in current path=0A=09=09=09=09else=0A=09=09=09=
=09=09e.classList.add("hide");=0A=09=09=09}=0A=09=09=09// Children maybe=0A=
=09=09=09else {=0A=09=09=09=09// no common path=0A=09=09=09=09if (ex < xmin=
 || ex + fudge >=3D xmax) {=0A=09=09=09=09=09e.classList.add("hide");=0A=09=
=09=09=09}=0A=09=09=09=09else {=0A=09=09=09=09=09zoom_child(e, xmin, ratio)=
;=0A=09=09=09=09=09update_text(e);=0A=09=09=09=09}=0A=09=09=09}=0A=09=09}=
=0A=09=09search();=0A=09}=0A=09function unzoom(dont_update_text) {=0A=09=09=
unzoombtn.classList.add("hide");=0A=09=09var el =3D document.getElementById=
("frames").children;=0A=09=09for(var i =3D 0; i < el.length; i++) {=0A=09=
=09=09el[i].classList.remove("parent");=0A=09=09=09el[i].classList.remove("=
hide");=0A=09=09=09zoom_reset(el[i]);=0A=09=09=09if(!dont_update_text) upda=
te_text(el[i]);=0A=09=09}=0A=09=09search();=0A=09}=0A=09function clearzoom(=
) {=0A=09=09unzoom();=0A=0A=09=09// remove zoom state=0A=09=09var params =
=3D get_params();=0A=09=09if (params.x) delete params.x;=0A=09=09if (params=
.y) delete params.y;=0A=09=09history.replaceState(null, null, parse_params(=
params));=0A=09}=0A=0A=09// search=0A=09function toggle_ignorecase() {=0A=
=09=09ignorecase =3D !ignorecase;=0A=09=09if (ignorecase) {=0A=09=09=09igno=
recaseBtn.classList.add("show");=0A=09=09} else {=0A=09=09=09ignorecaseBtn.=
classList.remove("show");=0A=09=09}=0A=09=09reset_search();=0A=09=09search(=
);=0A=09}=0A=09function reset_search() {=0A=09=09var el =3D document.queryS=
electorAll("#frames rect");=0A=09=09for (var i =3D 0; i < el.length; i++) {=
=0A=09=09=09orig_load(el[i], "fill")=0A=09=09}=0A=09=09var params =3D get_p=
arams();=0A=09=09delete params.s;=0A=09=09history.replaceState(null, null, =
parse_params(params));=0A=09}=0A=09function search_prompt() {=0A=09=09if (!=
searching) {=0A=09=09=09var term =3D prompt("Enter a search term (regexp " =
+=0A=09=09=09    "allowed, eg: ^ext4_)"=0A=09=09=09    + (ignorecase ? ", i=
gnoring case" : "")=0A=09=09=09    + "\nPress Ctrl-i to toggle case sensiti=
vity", "");=0A=09=09=09if (term !=3D null) search(term);=0A=09=09} else {=
=0A=09=09=09reset_search();=0A=09=09=09searching =3D 0;=0A=09=09=09currentS=
earchTerm =3D null;=0A=09=09=09searchbtn.classList.remove("show");=0A=09=09=
=09searchbtn.firstChild.nodeValue =3D "Search"=0A=09=09=09matchedtxt.classL=
ist.add("hide");=0A=09=09=09matchedtxt.firstChild.nodeValue =3D ""=0A=09=09=
}=0A=09}=0A=09function search(term) {=0A=09=09if (term) currentSearchTerm =
=3D term;=0A=0A=09=09var re =3D new RegExp(currentSearchTerm, ignorecase ? =
'i' : '');=0A=09=09var el =3D document.getElementById("frames").children;=
=0A=09=09var matches =3D new Object();=0A=09=09var maxwidth =3D 0;=0A=09=09=
for (var i =3D 0; i < el.length; i++) {=0A=09=09=09var e =3D el[i];=0A=09=
=09=09var func =3D g_to_func(e);=0A=09=09=09var rect =3D find_child(e, "rec=
t");=0A=09=09=09if (func =3D=3D null || rect =3D=3D null)=0A=09=09=09=09con=
tinue;=0A=0A=09=09=09// Save max width. Only works as we have a root frame=
=0A=09=09=09var w =3D parseFloat(rect.attributes.width.value);=0A=09=09=09i=
f (w > maxwidth)=0A=09=09=09=09maxwidth =3D w;=0A=0A=09=09=09if (func.match=
(re)) {=0A=09=09=09=09// highlight=0A=09=09=09=09var x =3D parseFloat(rect.=
attributes.x.value);=0A=09=09=09=09orig_save(rect, "fill");=0A=09=09=09=09r=
ect.attributes.fill.value =3D "rgb(230,0,230)";=0A=0A=09=09=09=09// remembe=
r matches=0A=09=09=09=09if (matches[x] =3D=3D undefined) {=0A=09=09=09=09=
=09matches[x] =3D w;=0A=09=09=09=09} else {=0A=09=09=09=09=09if (w > matche=
s[x]) {=0A=09=09=09=09=09=09// overwrite with parent=0A=09=09=09=09=09=09ma=
tches[x] =3D w;=0A=09=09=09=09=09}=0A=09=09=09=09}=0A=09=09=09=09searching =
=3D 1;=0A=09=09=09}=0A=09=09}=0A=09=09if (!searching)=0A=09=09=09return;=0A=
=09=09var params =3D get_params();=0A=09=09params.s =3D currentSearchTerm;=
=0A=09=09history.replaceState(null, null, parse_params(params));=0A=0A=09=
=09searchbtn.classList.add("show");=0A=09=09searchbtn.firstChild.nodeValue =
=3D "Reset Search";=0A=0A=09=09// calculate percent matched, excluding vert=
ical overlap=0A=09=09var count =3D 0;=0A=09=09var lastx =3D -1;=0A=09=09var=
 lastw =3D 0;=0A=09=09var keys =3D Array();=0A=09=09for (k in matches) {=0A=
=09=09=09if (matches.hasOwnProperty(k))=0A=09=09=09=09keys.push(k);=0A=09=
=09}=0A=09=09// sort the matched frames by their x location=0A=09=09// asce=
nding, then width descending=0A=09=09keys.sort(function(a, b){=0A=09=09=09r=
eturn a - b;=0A=09=09});=0A=09=09// Step through frames saving only the big=
gest bottom-up frames=0A=09=09// thanks to the sort order. This relies on t=
he tree property=0A=09=09// where children are always smaller than their pa=
rents.=0A=09=09var fudge =3D 0.0001;=09// JavaScript floating point=0A=09=
=09for (var k in keys) {=0A=09=09=09var x =3D parseFloat(keys[k]);=0A=09=09=
=09var w =3D matches[keys[k]];=0A=09=09=09if (x >=3D lastx + lastw - fudge)=
 {=0A=09=09=09=09count +=3D w;=0A=09=09=09=09lastx =3D x;=0A=09=09=09=09las=
tw =3D w;=0A=09=09=09}=0A=09=09}=0A=09=09// display matched percent=0A=09=
=09matchedtxt.classList.remove("hide");=0A=09=09var pct =3D 100 * count / m=
axwidth;=0A=09=09if (pct !=3D 100) pct =3D pct.toFixed(1)=0A=09=09matchedtx=
t.firstChild.nodeValue =3D "Matched: " + pct + "%";=0A=09}=0A]]>=0A</script=
>=0A<rect x=3D"0.0" y=3D"0" width=3D"1200.0" height=3D"774.0" fill=3D"url(#=
background)"  />=0A<text id=3D"title" x=3D"600.00" y=3D"24" >Flame Graph</t=
ext>=0A<text id=3D"details" x=3D"10.00" y=3D"757" > </text>=0A<text id=3D"u=
nzoom" x=3D"10.00" y=3D"24" class=3D"hide">Reset Zoom</text>=0A<text id=3D"=
search" x=3D"1090.00" y=3D"24" >Search</text>=0A<text id=3D"ignorecase" x=
=3D"1174.00" y=3D"24" >ic</text>=0A<text id=3D"matched" x=3D"1090.00" y=3D"=
757" > </text>=0A<g id=3D"frames">=0A<g >=0A<title>check_preemption_disable=
d (128,490,026 samples, 0.02%)</title><rect x=3D"743.0" y=3D"549" width=3D"=
0.3" height=3D"15.0" fill=3D"rgb(239,173,18)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"746.05" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>vm_normal_page (7=
2,695,930 samples, 0.01%)</title><rect x=3D"360.9" y=3D"453" width=3D"0.2" =
height=3D"15.0" fill=3D"rgb(217,206,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"363.89" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disab=
led (160,555,073 samples, 0.03%)</title><rect x=3D"794.2" y=3D"533" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(222,204,6)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"797.23" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>fput (866,418,=
551 samples, 0.17%)</title><rect x=3D"957.8" y=3D"613" width=3D"1.9" height=
=3D"15.0" fill=3D"rgb(239,99,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"960.78=
" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>change_prot_numa (650,309,023=
 samples, 0.12%)</title><rect x=3D"1167.1" y=3D"581" width=3D"1.4" height=
=3D"15.0" fill=3D"rgb(253,85,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.0=
7" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>tg3_poll_msix (147,822,297 s=
amples, 0.03%)</title><rect x=3D"477.3" y=3D"213" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(206,173,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_group (319,857,724 sa=
mples, 0.06%)</title><rect x=3D"1075.5" y=3D"389" width=3D"0.7" height=3D"1=
5.0" fill=3D"rgb(242,73,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1078.49" y=
=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>user_return_notifier_register (3=
43,316,612 samples, 0.07%)</title><rect x=3D"744.9" y=3D"549" width=3D"0.7"=
 height=3D"15.0" fill=3D"rgb(242,77,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"747.86" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disab=
led (270,461,772 samples, 0.05%)</title><rect x=3D"1090.8" y=3D"421" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(228,114,34)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1093.77" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_6=
4 (108,000,141,127 samples, 20.73%)</title><rect x=3D"927.7" y=3D"661" widt=
h=3D"244.6" height=3D"15.0" fill=3D"rgb(207,143,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"930.69" y=3D"671.5" >do_syscall_64</text>=0A</g>=0A<g >=0A<t=
itle>native_sched_clock (441,161,464 samples, 0.08%)</title><rect x=3D"649.=
3" y=3D"293" width=3D"1.0" height=3D"15.0" fill=3D"rgb(239,180,29)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"652.34" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<t=
itle>native_queued_spin_lock_slowpath (5,416,194,316 samples, 1.04%)</title=
><rect x=3D"37.0" y=3D"485" width=3D"12.3" height=3D"15.0" fill=3D"rgb(222,=
7,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.99" y=3D"495.5" ></text>=0A</g=
>=0A<g >=0A<title>x86_pmu_disable (373,521,407 samples, 0.07%)</title><rect=
 x=3D"997.9" y=3D"549" width=3D"0.8" height=3D"15.0" fill=3D"rgb(246,208,48=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1000.88" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>__vdso_clock_gettime (656,662,395 samples, 0.13%)</title><=
rect x=3D"207.8" y=3D"645" width=3D"1.5" height=3D"15.0" fill=3D"rgb(236,18=
5,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"210.79" y=3D"655.5" ></text>=0A</=
g>=0A<g >=0A<title>is_valid_gup_args (246,750,720 samples, 0.05%)</title><r=
ect x=3D"679.2" y=3D"485" width=3D"0.5" height=3D"15.0" fill=3D"rgb(246,124=
,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"682.15" y=3D"495.5" ></text>=0A</g=
>=0A<g >=0A<title>cgroup_base_stat_cputime_account_end.isra.12 (750,010,037=
 samples, 0.14%)</title><rect x=3D"1018.4" y=3D"517" width=3D"1.7" height=
=3D"15.0" fill=3D"rgb(221,192,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1021.4=
2" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>in_lock_functions (906,482,0=
44 samples, 0.17%)</title><rect x=3D"979.8" y=3D"549" width=3D"2.1" height=
=3D"15.0" fill=3D"rgb(206,217,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"982.84=
" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (625,495,838=
 samples, 0.12%)</title><rect x=3D"1179.0" y=3D"661" width=3D"1.4" height=
=3D"15.0" fill=3D"rgb(250,188,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.=
99" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1,532,181=
,808 samples, 0.29%)</title><rect x=3D"29.3" y=3D"501" width=3D"3.5" height=
=3D"15.0" fill=3D"rgb(209,117,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.33"=
 y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>cgroup_rstat_updated (305,813,=
146 samples, 0.06%)</title><rect x=3D"702.1" y=3D"437" width=3D"0.7" height=
=3D"15.0" fill=3D"rgb(243,222,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"705.0=
7" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>set_task_rq_fair (106,906,38=
8 samples, 0.02%)</title><rect x=3D"430.9" y=3D"277" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(236,55,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"433.91"=
 y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>free_swap_cache (44,718,174 sa=
mples, 0.01%)</title><rect x=3D"1182.1" y=3D"485" width=3D"0.1" height=3D"1=
5.0" fill=3D"rgb(206,159,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.09" y=
=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>up_read (2,215,722,730 samples, =
0.43%)</title><rect x=3D"687.0" y=3D"501" width=3D"5.0" height=3D"15.0" fil=
l=3D"rgb(246,205,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"689.99" y=3D"511.5=
" ></text>=0A</g>=0A<g >=0A<title>update_blocked_averages (219,805,393 samp=
les, 0.04%)</title><rect x=3D"970.9" y=3D"501" width=3D"0.5" height=3D"15.0=
" fill=3D"rgb(249,213,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"973.94" y=3D"=
511.5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_group (296,409,774 sample=
s, 0.06%)</title><rect x=3D"1035.6" y=3D"549" width=3D"0.6" height=3D"15.0"=
 fill=3D"rgb(232,95,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1038.58" y=3D"5=
59.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (3,92=
4,643,507 samples, 0.75%)</title><rect x=3D"1069.6" y=3D"549" width=3D"8.9"=
 height=3D"15.0" fill=3D"rgb(228,17,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1072.59" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (31=
8,427,549 samples, 0.06%)</title><rect x=3D"352.8" y=3D"437" width=3D"0.7" =
height=3D"15.0" fill=3D"rgb(227,71,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"3=
55.80" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>kvm_on_user_return (1,78=
2,441,282 samples, 0.34%)</title><rect x=3D"1154.9" y=3D"597" width=3D"4.1"=
 height=3D"15.0" fill=3D"rgb(207,35,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1157.92" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>attach_task (188,276,=
732 samples, 0.04%)</title><rect x=3D"632.9" y=3D"277" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(254,198,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"635.8=
8" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>update_rq_clock (352,418,182=
 samples, 0.07%)</title><rect x=3D"436.6" y=3D"293" width=3D"0.8" height=3D=
"15.0" fill=3D"rgb(225,145,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"439.61" =
y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (2,726,531,926 s=
amples, 0.52%)</title><rect x=3D"1070.7" y=3D"421" width=3D"6.2" height=3D"=
15.0" fill=3D"rgb(216,26,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.69" y=
=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>activate_task (493,616,072 sampl=
es, 0.09%)</title><rect x=3D"1090.8" y=3D"501" width=3D"1.1" height=3D"15.0=
" fill=3D"rgb(207,5,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1093.77" y=3D"51=
1.5" ></text>=0A</g>=0A<g >=0A<title>vmx_handle_exit (68,647,577 samples, 0=
.01%)</title><rect x=3D"10.3" y=3D"549" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(219,217,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"559.5" =
></text>=0A</g>=0A<g >=0A<title>handle_uffd_page_request (133,514,485 sampl=
es, 0.03%)</title><rect x=3D"1185.0" y=3D"693" width=3D"0.3" height=3D"15.0=
" fill=3D"rgb(245,56,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1187.96" y=3D"=
703.5" ></text>=0A</g>=0A<g >=0A<title>on_each_cpu_cond_mask (242,233,493 s=
amples, 0.05%)</title><rect x=3D"1168.0" y=3D"517" width=3D"0.5" height=3D"=
15.0" fill=3D"rgb(251,203,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.00" =
y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>mfill_atomic_install_pte (6,274=
,742,692 samples, 1.20%)</title><rect x=3D"867.1" y=3D"597" width=3D"14.2" =
height=3D"15.0" fill=3D"rgb(244,169,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"870.09" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (362=
,040,771 samples, 0.07%)</title><rect x=3D"991.8" y=3D"533" width=3D"0.9" h=
eight=3D"15.0" fill=3D"rgb(216,185,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
994.85" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>rcu_preempt_deferred_qs=
 (202,377,341 samples, 0.04%)</title><rect x=3D"1133.7" y=3D"549" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(213,165,0)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1136.74" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>reweight_entity (=
165,891,205 samples, 0.03%)</title><rect x=3D"465.6" y=3D"309" width=3D"0.3=
" height=3D"15.0" fill=3D"rgb(235,122,27)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"468.57" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (1=
51,196,233 samples, 0.03%)</title><rect x=3D"919.5" y=3D"597" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(250,132,47)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"922.49" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_c=
fs_rq (188,738,100 samples, 0.04%)</title><rect x=3D"1036.2" y=3D"533" widt=
h=3D"0.5" height=3D"15.0" fill=3D"rgb(219,190,19)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1039.25" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>do_vmi_alig=
n_munmap (1,259,337,616 samples, 0.24%)</title><rect x=3D"1180.4" y=3D"581"=
 width=3D"2.9" height=3D"15.0" fill=3D"rgb(206,152,18)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1183.41" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>_copy_=
from_user (152,022,388 samples, 0.03%)</title><rect x=3D"837.4" y=3D"613" w=
idth=3D"0.3" height=3D"15.0" fill=3D"rgb(231,88,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"840.38" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>error_en=
try (160,096,179 samples, 0.03%)</title><rect x=3D"623.6" y=3D"261" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(246,156,6)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"626.62" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_un=
lock (811,146,198 samples, 0.16%)</title><rect x=3D"1062.3" y=3D"517" width=
=3D"1.9" height=3D"15.0" fill=3D"rgb(207,140,54)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1065.32" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>syscall_trac=
e_enter.isra.17 (900,442,836 samples, 0.17%)</title><rect x=3D"194.1" y=3D"=
629" width=3D"2.1" height=3D"15.0" fill=3D"rgb(207,151,54)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"197.15" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>tic=
k_sched_handle.isra.21 (58,323,375 samples, 0.01%)</title><rect x=3D"439.1"=
 y=3D"229" width=3D"0.1" height=3D"15.0" fill=3D"rgb(228,127,27)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"442.11" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<tit=
le>syscall_trace_enter.isra.17 (985,187,341 samples, 0.19%)</title><rect x=
=3D"222.5" y=3D"629" width=3D"2.3" height=3D"15.0" fill=3D"rgb(244,196,14)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"225.53" y=3D"639.5" ></text>=0A</g>=0A<=
g >=0A<title>_raw_spin_unlock_irqrestore (49,090,332 samples, 0.01%)</title=
><rect x=3D"406.8" y=3D"293" width=3D"0.1" height=3D"15.0" fill=3D"rgb(219,=
128,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"409.78" y=3D"303.5" ></text>=0A=
</g>=0A<g >=0A<title>mcopy_continue (9,376,093,848 samples, 1.80%)</title><=
rect x=3D"108.9" y=3D"597" width=3D"21.3" height=3D"15.0" fill=3D"rgb(228,1=
35,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.93" y=3D"607.5" ></text>=0A<=
/g>=0A<g >=0A<title>__rcu_read_unlock (133,034,558 samples, 0.03%)</title><=
rect x=3D"638.6" y=3D"293" width=3D"0.3" height=3D"15.0" fill=3D"rgb(210,20=
0,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"641.63" y=3D"303.5" ></text>=0A</=
g>=0A<g >=0A<title>__x64_sys_poll (99,282,833,578 samples, 19.05%)</title><=
rect x=3D"928.1" y=3D"645" width=3D"224.9" height=3D"15.0" fill=3D"rgb(216,=
47,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"931.11" y=3D"655.5" >__x64_sys_p=
oll</text>=0A</g>=0A<g >=0A<title>task_numa_work (143,136,218 samples, 0.03=
%)</title><rect x=3D"806.0" y=3D"565" width=3D"0.4" height=3D"15.0" fill=3D=
"rgb(249,81,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"575.5" ></=
text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (151,196,233 samples, 0.03%)=
</title><rect x=3D"919.5" y=3D"629" width=3D"0.3" height=3D"15.0" fill=3D"r=
gb(230,184,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"639.5" ></t=
ext>=0A</g>=0A<g >=0A<title>preempt_count_sub (220,920,390 samples, 0.04%)<=
/title><rect x=3D"187.6" y=3D"565" width=3D"0.5" height=3D"15.0" fill=3D"rg=
b(218,117,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"190.57" y=3D"575.5" ></te=
xt>=0A</g>=0A<g >=0A<title>kvm_mmu_notifier_invalidate_range_start (133,589=
,906 samples, 0.03%)</title><rect x=3D"806.0" y=3D"501" width=3D"0.3" heigh=
t=3D"15.0" fill=3D"rgb(238,76,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.0=
5" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>internal_get_user_pages_fast=
 (8,851,404,735 samples, 1.70%)</title><rect x=3D"292.3" y=3D"485" width=3D=
"20.1" height=3D"15.0" fill=3D"rgb(241,191,40)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"295.33" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__fput (625,495=
,838 samples, 0.12%)</title><rect x=3D"1179.0" y=3D"581" width=3D"1.4" heig=
ht=3D"15.0" fill=3D"rgb(217,164,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"118=
1.99" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__libc_read (1,213,240,84=
0 samples, 0.23%)</title><rect x=3D"911.7" y=3D"693" width=3D"2.7" height=
=3D"15.0" fill=3D"rgb(234,117,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"914.6=
6" y=3D"703.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (4=
53,456,531 samples, 0.09%)</title><rect x=3D"993.9" y=3D"533" width=3D"1.1"=
 height=3D"15.0" fill=3D"rgb(216,105,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"996.93" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__flush_smp_call_funct=
ion_queue (540,033,948 samples, 0.10%)</title><rect x=3D"1080.2" y=3D"501" =
width=3D"1.2" height=3D"15.0" fill=3D"rgb(246,59,9)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1083.16" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>try_to_=
unmap_flush (181,644,572 samples, 0.03%)</title><rect x=3D"662.8" y=3D"389"=
 width=3D"0.4" height=3D"15.0" fill=3D"rgb(226,36,35)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"665.79" y=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>psi_grou=
p_change (173,876,831 samples, 0.03%)</title><rect x=3D"632.9" y=3D"229" wi=
dth=3D"0.4" height=3D"15.0" fill=3D"rgb(243,141,11)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"635.91" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>syscall_=
exit_to_user_mode_prepare (1,500,398,966 samples, 0.29%)</title><rect x=3D"=
1168.5" y=3D"629" width=3D"3.4" height=3D"15.0" fill=3D"rgb(207,161,37)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1171.55" y=3D"639.5" ></text>=0A</g>=0A<g =
>=0A<title>in_lock_functions (300,279,446 samples, 0.06%)</title><rect x=3D=
"678.0" y=3D"453" width=3D"0.6" height=3D"15.0" fill=3D"rgb(251,15,11)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"680.96" y=3D"463.5" ></text>=0A</g>=0A<g >=
=0A<title>finish_task_switch (20,481,115,444 samples, 3.93%)</title><rect x=
=3D"1036.7" y=3D"565" width=3D"46.4" height=3D"15.0" fill=3D"rgb(222,107,47=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1039.72" y=3D"575.5" >fini..</text>=
=0A</g>=0A<g >=0A<title>__fget_light (1,786,150,921 samples, 0.34%)</title>=
<rect x=3D"249.6" y=3D"629" width=3D"4.1" height=3D"15.0" fill=3D"rgb(211,2=
1,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"252.63" y=3D"639.5" ></text>=0A</g=
>=0A<g >=0A<title>debug_smp_processor_id (147,709,751 samples, 0.03%)</titl=
e><rect x=3D"449.2" y=3D"325" width=3D"0.3" height=3D"15.0" fill=3D"rgb(231=
,40,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"452.19" y=3D"335.5" ></text>=0A=
</g>=0A<g >=0A<title>add_wait_queue (1,402,082,356 samples, 0.27%)</title><=
rect x=3D"967.2" y=3D"597" width=3D"3.1" height=3D"15.0" fill=3D"rgb(225,17=
5,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"970.15" y=3D"607.5" ></text>=0A</=
g>=0A<g >=0A<title>asm_sysvec_call_function_single (148,612,585 samples, 0.=
03%)</title><rect x=3D"448.9" y=3D"325" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(242,177,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"451.86" y=3D"335.5"=
 ></text>=0A</g>=0A<g >=0A<title>__mod_memcg_lruvec_state (44,430,129 sampl=
es, 0.01%)</title><rect x=3D"1180.2" y=3D"405" width=3D"0.1" height=3D"15.0=
" fill=3D"rgb(232,151,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.16" y=3D"=
415.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock (130,717,024 samples,=
 0.03%)</title><rect x=3D"652.3" y=3D"309" width=3D"0.3" height=3D"15.0" fi=
ll=3D"rgb(210,224,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"655.33" y=3D"319.5=
" ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_se (448,167,760 samples=
, 0.09%)</title><rect x=3D"1031.3" y=3D"517" width=3D"1.0" height=3D"15.0" =
fill=3D"rgb(205,205,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1034.26" y=3D"5=
27.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (535,531,710 samples=
, 0.10%)</title><rect x=3D"437.6" y=3D"325" width=3D"1.2" height=3D"15.0" f=
ill=3D"rgb(230,155,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"440.56" y=3D"335=
.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock (362,040,771 samples, 0.=
07%)</title><rect x=3D"991.8" y=3D"549" width=3D"0.9" height=3D"15.0" fill=
=3D"rgb(254,92,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"994.85" y=3D"559.5" =
></text>=0A</g>=0A<g >=0A<title>follow_page_pte (4,247,536,094 samples, 0.8=
2%)</title><rect x=3D"351.4" y=3D"469" width=3D"9.7" height=3D"15.0" fill=
=3D"rgb(213,207,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"354.43" y=3D"479.5"=
 ></text>=0A</g>=0A<g >=0A<title>__flush_smp_call_function_queue (258,005,6=
54 samples, 0.05%)</title><rect x=3D"164.6" y=3D"517" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(242,214,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.5=
6" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__flush_smp_call_function_qu=
eue (166,489,982 samples, 0.03%)</title><rect x=3D"439.3" y=3D"277" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(221,170,49)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"442.30" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_ta=
sk_tick (703,920,444 samples, 0.14%)</title><rect x=3D"615.8" y=3D"101" wid=
th=3D"1.6" height=3D"15.0" fill=3D"rgb(226,13,29)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"618.85" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>irq_exit_rcu=
 (207,512,187 samples, 0.04%)</title><rect x=3D"1078.0" y=3D"517" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(234,7,7)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1081.01" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>mmput (4,777,275,5=
39 samples, 0.92%)</title><rect x=3D"130.2" y=3D"597" width=3D"10.8" height=
=3D"15.0" fill=3D"rgb(207,67,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"133.17=
" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (=
219,805,393 samples, 0.04%)</title><rect x=3D"970.9" y=3D"565" width=3D"0.5=
" height=3D"15.0" fill=3D"rgb(222,107,52)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"973.94" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lruvec_page_s=
tate (402,864,086 samples, 0.08%)</title><rect x=3D"1182.2" y=3D"469" width=
=3D"1.0" height=3D"15.0" fill=3D"rgb(245,36,42)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1185.25" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>cpus_share_ca=
che (175,018,084 samples, 0.03%)</title><rect x=3D"424.4" y=3D"277" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(228,73,6)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"427.35" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>security_file_i=
octl (3,931,051,512 samples, 0.75%)</title><rect x=3D"806.4" y=3D"629" widt=
h=3D"8.9" height=3D"15.0" fill=3D"rgb(236,177,44)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"809.37" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>preempt_coun=
t_sub (484,776,521 samples, 0.09%)</title><rect x=3D"1068.5" y=3D"533" widt=
h=3D"1.1" height=3D"15.0" fill=3D"rgb(219,55,42)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1071.50" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>mmu_topup_me=
mory_caches (609,837,112 samples, 0.12%)</title><rect x=3D"731.6" y=3D"533"=
 width=3D"1.4" height=3D"15.0" fill=3D"rgb(247,216,40)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"734.63" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>preempt=
_count_sub (158,942,648 samples, 0.03%)</title><rect x=3D"35.0" y=3D"501" w=
idth=3D"0.3" height=3D"15.0" fill=3D"rgb(219,222,3)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"37.97" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>preempt_c=
ount_sub (570,800,605 samples, 0.11%)</title><rect x=3D"188.4" y=3D"565" wi=
dth=3D"1.3" height=3D"15.0" fill=3D"rgb(239,125,21)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"191.36" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>check_pr=
eemption_disabled (278,618,181 samples, 0.05%)</title><rect x=3D"1180.4" y=
=3D"485" width=3D"0.6" height=3D"15.0" fill=3D"rgb(222,27,38)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1183.41" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<titl=
e>preempt_count_add (199,912,819 samples, 0.04%)</title><rect x=3D"280.0" y=
=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(224,55,20)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"283.04" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title=
>__cgroup_account_cputime (239,807,166 samples, 0.05%)</title><rect x=3D"10=
17.9" y=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(233,223,6)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"1020.88" y=3D"527.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_irqsave (2,090,485,032 samples, 0.40%)</title><rec=
t x=3D"29.3" y=3D"517" width=3D"4.7" height=3D"15.0" fill=3D"rgb(234,106,10=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"32.28" y=3D"527.5" ></text>=0A</g>=0A=
<g >=0A<title>ktime_get_coarse_real_ts64 (125,984,060 samples, 0.02%)</titl=
e><rect x=3D"1172.0" y=3D"629" width=3D"0.3" height=3D"15.0" fill=3D"rgb(21=
1,192,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1175.00" y=3D"639.5" ></text>=
=0A</g>=0A<g >=0A<title>free_pages_and_swap_cache (68,606,677 samples, 0.01=
%)</title><rect x=3D"1182.0" y=3D"501" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(209,140,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.04" y=3D"511.5=
" ></text>=0A</g>=0A<g >=0A<title>syscall_return_via_sysret (3,460,085,386 =
samples, 0.66%)</title><rect x=3D"224.8" y=3D"661" width=3D"7.8" height=3D"=
15.0" fill=3D"rgb(241,75,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"227.78" y=
=3D"671.5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_rq_h_load (1,069,128,=
154 samples, 0.21%)</title><rect x=3D"424.8" y=3D"277" width=3D"2.4" height=
=3D"15.0" fill=3D"rgb(229,198,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"427.7=
9" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (919,=
455,376 samples, 0.18%)</title><rect x=3D"704.1" y=3D"453" width=3D"2.1" he=
ight=3D"15.0" fill=3D"rgb(229,17,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"70=
7.11" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (297,26=
3,649 samples, 0.06%)</title><rect x=3D"268.1" y=3D"581" width=3D"0.6" heig=
ht=3D"15.0" fill=3D"rgb(210,203,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"271=
.08" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_irqrestor=
e (149,972,130 samples, 0.03%)</title><rect x=3D"966.8" y=3D"597" width=3D"=
0.4" height=3D"15.0" fill=3D"rgb(234,7,11)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"969.81" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>enqueue_task_fair (=
493,616,072 samples, 0.09%)</title><rect x=3D"1090.8" y=3D"485" width=3D"1.=
1" height=3D"15.0" fill=3D"rgb(213,178,10)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1093.77" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__munmap (1,259,33=
7,616 samples, 0.24%)</title><rect x=3D"1180.4" y=3D"677" width=3D"2.9" hei=
ght=3D"15.0" fill=3D"rgb(205,142,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
83.41" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>inode_has_perm (333,772,=
355 samples, 0.06%)</title><rect x=3D"175.1" y=3D"565" width=3D"0.7" height=
=3D"15.0" fill=3D"rgb(242,192,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"178.0=
9" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>_copy_from_user (62,309,870 =
samples, 0.01%)</title><rect x=3D"957.6" y=3D"613" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(246,214,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"960.59" y=
=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (192=
,863,815 samples, 0.04%)</title><rect x=3D"440.1" y=3D"341" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(248,85,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"44=
3.07" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>workingset_age_nonresiden=
t (2,481,592,843 samples, 0.48%)</title><rect x=3D"709.3" y=3D"485" width=
=3D"5.6" height=3D"15.0" fill=3D"rgb(207,123,5)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"712.27" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_=
64 (82,977,526 samples, 0.02%)</title><rect x=3D"10.3" y=3D"645" width=3D"0=
.2" height=3D"15.0" fill=3D"rgb(250,145,45)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"13.30" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>schedule (70,960,50=
3,676 samples, 13.62%)</title><rect x=3D"982.5" y=3D"597" width=3D"160.7" h=
eight=3D"15.0" fill=3D"rgb(234,97,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"9=
85.46" y=3D"607.5" >schedule</text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock=
_irqrestore (300,851,105 samples, 0.06%)</title><rect x=3D"1150.6" y=3D"597=
" width=3D"0.6" height=3D"15.0" fill=3D"rgb(216,142,35)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"1153.56" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>down_=
read (6,487,603,550 samples, 1.25%)</title><rect x=3D"841.7" y=3D"597" widt=
h=3D"14.7" height=3D"15.0" fill=3D"rgb(233,226,36)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"844.72" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>record_time=
s (212,888,184 samples, 0.04%)</title><rect x=3D"648.8" y=3D"293" width=3D"=
0.5" height=3D"15.0" fill=3D"rgb(207,31,46)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"651.81" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (=
558,945,724 samples, 0.11%)</title><rect x=3D"440.7" y=3D"357" width=3D"1.2=
" height=3D"15.0" fill=3D"rgb(208,67,45)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"443.66" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>syscall_return_via_=
sysret (2,304,203,614 samples, 0.44%)</title><rect x=3D"196.2" y=3D"661" wi=
dth=3D"5.2" height=3D"15.0" fill=3D"rgb(210,73,0)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"199.19" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<title>xas_descend =
(624,686,460 samples, 0.12%)</title><rect x=3D"385.8" y=3D"341" width=3D"1.=
4" height=3D"15.0" fill=3D"rgb(236,119,2)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"388.83" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>unmap_vmas (958,554=
,674 samples, 0.18%)</title><rect x=3D"1181.1" y=3D"549" width=3D"2.2" heig=
ht=3D"15.0" fill=3D"rgb(250,149,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"118=
4.09" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq =
(257,105,812 samples, 0.05%)</title><rect x=3D"90.8" y=3D"469" width=3D"0.6=
" height=3D"15.0" fill=3D"rgb(244,130,1)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"93.83" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>find_busiest_group (=
957,401,295 samples, 0.18%)</title><rect x=3D"1092.2" y=3D"517" width=3D"2.=
2" height=3D"15.0" fill=3D"rgb(207,125,8)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1095.24" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_common_l=
ock (16,132,777,898 samples, 3.10%)</title><rect x=3D"403.5" y=3D"357" widt=
h=3D"36.5" height=3D"15.0" fill=3D"rgb(212,26,37)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"406.51" y=3D"367.5" >__w..</text>=0A</g>=0A<g >=0A<title>[unknow=
n] (85,560,303 samples, 0.02%)</title><rect x=3D"10.0" y=3D"597" width=3D"0=
.2" height=3D"15.0" fill=3D"rgb(213,12,16)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.00" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>kvm_sched_in (1,807,=
867,497 samples, 0.35%)</title><rect x=3D"624.0" y=3D"309" width=3D"4.1" he=
ight=3D"15.0" fill=3D"rgb(235,46,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"626=
.98" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (216,067,470 sam=
ples, 0.04%)</title><rect x=3D"10.0" y=3D"677" width=3D"0.5" height=3D"15.0=
" fill=3D"rgb(221,162,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"6=
87.5" ></text>=0A</g>=0A<g >=0A<title>newidle_balance (3,908,828,722 sample=
s, 0.75%)</title><rect x=3D"629.5" y=3D"309" width=3D"8.8" height=3D"15.0" =
fill=3D"rgb(245,171,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"632.47" y=3D"31=
9.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (99,319,957,606 samples, 19.=
06%)</title><rect x=3D"10.0" y=3D"693" width=3D"224.9" height=3D"15.0" fill=
=3D"rgb(222,0,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"703.5" >[=
unknown]</text>=0A</g>=0A<g >=0A<title>psi_task_change (362,375,070 samples=
, 0.07%)</title><rect x=3D"431.5" y=3D"277" width=3D"0.8" height=3D"15.0" f=
ill=3D"rgb(254,75,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434.47" y=3D"287.=
5" ></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (265,842,=
308 samples, 0.05%)</title><rect x=3D"107.7" y=3D"421" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(223,5,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74"=
 y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (1,051,100,9=
14 samples, 0.20%)</title><rect x=3D"477.7" y=3D"261" width=3D"2.4" height=
=3D"15.0" fill=3D"rgb(231,185,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.6=
9" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (50,867,740=
 samples, 0.01%)</title><rect x=3D"477.2" y=3D"309" width=3D"0.1" height=3D=
"15.0" fill=3D"rgb(217,37,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.19" y=
=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__x2apic_send_IPI_dest (973,910,=
468 samples, 0.19%)</title><rect x=3D"433.3" y=3D"277" width=3D"2.2" height=
=3D"15.0" fill=3D"rgb(220,192,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"436.2=
6" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>perf_pmu_disable (787,936,85=
2 samples, 0.15%)</title><rect x=3D"995.0" y=3D"549" width=3D"1.7" height=
=3D"15.0" fill=3D"rgb(237,229,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"997.9=
5" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>__netif_receive_skb_list_cor=
e (147,822,297 samples, 0.03%)</title><rect x=3D"477.3" y=3D"165" width=3D"=
0.3" height=3D"15.0" fill=3D"rgb(251,113,15)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"480.30" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>sched_clock (240,=
814,759 samples, 0.05%)</title><rect x=3D"99.6" y=3D"485" width=3D"0.5" hei=
ght=3D"15.0" fill=3D"rgb(252,89,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"102=
.56" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled =
(195,016,500 samples, 0.04%)</title><rect x=3D"803.1" y=3D"549" width=3D"0.=
5" height=3D"15.0" fill=3D"rgb(213,118,40)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"806.12" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1=
,179,509,584 samples, 0.23%)</title><rect x=3D"355.3" y=3D"453" width=3D"2.=
7" height=3D"15.0" fill=3D"rgb(253,156,12)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"358.29" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (22=
3,154,300 samples, 0.04%)</title><rect x=3D"1091.4" y=3D"453" width=3D"0.5"=
 height=3D"15.0" fill=3D"rgb(239,165,26)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1094.38" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>xas_load (1,993,14=
7,083 samples, 0.38%)</title><rect x=3D"383.8" y=3D"357" width=3D"4.5" heig=
ht=3D"15.0" fill=3D"rgb(251,99,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"386.=
82" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (4,599,576,69=
3 samples, 0.88%)</title><rect x=3D"214.3" y=3D"645" width=3D"10.5" height=
=3D"15.0" fill=3D"rgb(234,0,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"217.34"=
 y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>__srcu_read_unlock (557,494,87=
8 samples, 0.11%)</title><rect x=3D"262.3" y=3D"581" width=3D"1.3" height=
=3D"15.0" fill=3D"rgb(222,117,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"265.3=
2" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__update_idle_core (528,349,=
682 samples, 0.10%)</title><rect x=3D"638.9" y=3D"293" width=3D"1.2" height=
=3D"15.0" fill=3D"rgb(218,228,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"641.93=
" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_sing=
le (962,235,148 samples, 0.18%)</title><rect x=3D"480.3" y=3D"309" width=3D=
"2.1" height=3D"15.0" fill=3D"rgb(241,140,13)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"483.27" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>tdp_iter_restart=
 (56,062,701 samples, 0.01%)</title><rect x=3D"730.7" y=3D"517" width=3D"0.=
2" height=3D"15.0" fill=3D"rgb(249,28,24)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"733.73" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__irqentry_text_end=
 (307,103,929 samples, 0.06%)</title><rect x=3D"151.3" y=3D"661" width=3D"0=
.7" height=3D"15.0" fill=3D"rgb(211,30,28)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"154.32" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<title>llist_reverse_order=
 (258,005,654 samples, 0.05%)</title><rect x=3D"164.6" y=3D"501" width=3D"0=
.5" height=3D"15.0" fill=3D"rgb(254,186,53)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"167.56" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__perf_event_task_=
sched_out (3,685,162,410 samples, 0.71%)</title><rect x=3D"990.4" y=3D"565"=
 width=3D"8.3" height=3D"15.0" fill=3D"rgb(232,19,43)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"993.38" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>check_pr=
eemption_disabled (273,208,567 samples, 0.05%)</title><rect x=3D"998.7" y=
=3D"565" width=3D"0.6" height=3D"15.0" fill=3D"rgb(214,168,50)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1001.73" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<titl=
e>do_raw_spin_lock (152,537,000 samples, 0.03%)</title><rect x=3D"406.4" y=
=3D"277" width=3D"0.4" height=3D"15.0" fill=3D"rgb(252,203,41)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"409.41" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title=
>switch_fpu_return (1,064,718,292 samples, 0.20%)</title><rect x=3D"268.8" =
y=3D"581" width=3D"2.4" height=3D"15.0" fill=3D"rgb(230,11,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"271.81" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>native_queued_spin_lock_slowpath (2,633,367,489 samples, 0.51%)</title><re=
ct x=3D"733.9" y=3D"517" width=3D"6.0" height=3D"15.0" fill=3D"rgb(226,221,=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"736.92" y=3D"527.5" ></text>=0A</g>=
=0A<g >=0A<title>update_load_avg (257,105,812 samples, 0.05%)</title><rect =
x=3D"90.8" y=3D"485" width=3D"0.6" height=3D"15.0" fill=3D"rgb(212,17,33)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"93.83" y=3D"495.5" ></text>=0A</g>=0A<g =
>=0A<title>vmx_vcpu_pi_load (1,064,105,263 samples, 0.20%)</title><rect x=
=3D"621.6" y=3D"277" width=3D"2.4" height=3D"15.0" fill=3D"rgb(227,178,30)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"624.57" y=3D"287.5" ></text>=0A</g>=0A<=
g >=0A<title>x2apic_send_IPI (342,535,925 samples, 0.07%)</title><rect x=3D=
"620.8" y=3D"229" width=3D"0.8" height=3D"15.0" fill=3D"rgb(205,103,40)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"623.78" y=3D"239.5" ></text>=0A</g>=0A<g >=
=0A<title>exit_to_user_mode_prepare (241,733,532 samples, 0.05%)</title><re=
ct x=3D"141.0" y=3D"613" width=3D"0.6" height=3D"15.0" fill=3D"rgb(235,216,=
17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.05" y=3D"623.5" ></text>=0A</g>=
=0A<g >=0A<title>tick_sched_handle.isra.21 (265,842,308 samples, 0.05%)</ti=
tle><rect x=3D"107.7" y=3D"485" width=3D"0.6" height=3D"15.0" fill=3D"rgb(2=
05,68,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"495.5" ></text>=
=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (1,017,883,970 samples,=
 0.20%)</title><rect x=3D"615.8" y=3D"229" width=3D"2.3" height=3D"15.0" fi=
ll=3D"rgb(206,76,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.80" y=3D"239.5"=
 ></text>=0A</g>=0A<g >=0A<title>get_cpu_entry_area (234,657,658 samples, 0=
.05%)</title><rect x=3D"494.5" y=3D"261" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(241,48,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"497.46" y=3D"271.5" =
></text>=0A</g>=0A<g >=0A<title>__update_load_avg_se (206,588,037 samples, =
0.04%)</title><rect x=3D"1098.3" y=3D"501" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(241,109,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1101.25" y=3D"511=
.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (55,184,398,320 samples, =
10.59%)</title><rect x=3D"17.9" y=3D"645" width=3D"125.0" height=3D"15.0" f=
ill=3D"rgb(241,169,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.88" y=3D"655.5=
" >do_syscall_64</text>=0A</g>=0A<g >=0A<title>__filemap_get_folio (5,295,5=
40,240 samples, 1.02%)</title><rect x=3D"894.9" y=3D"565" width=3D"12.0" he=
ight=3D"15.0" fill=3D"rgb(236,204,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"8=
97.91" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>ttwu_do_activate (500,83=
0,449 samples, 0.10%)</title><rect x=3D"431.2" y=3D"293" width=3D"1.1" heig=
ht=3D"15.0" fill=3D"rgb(222,110,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434=
.16" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>set_next_task_idle (1,879,=
586,038 samples, 0.36%)</title><rect x=3D"1100.1" y=3D"549" width=3D"4.3" h=
eight=3D"15.0" fill=3D"rgb(236,186,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1103.14" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>sched_clock (192,390,8=
44 samples, 0.04%)</title><rect x=3D"1128.0" y=3D"533" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(207,225,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1130.=
96" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>change_protection (46,889,2=
30 samples, 0.01%)</title><rect x=3D"141.5" y=3D"549" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(247,204,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.4=
9" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (297,=
626,848 samples, 0.06%)</title><rect x=3D"103.4" y=3D"565" width=3D"0.6" he=
ight=3D"15.0" fill=3D"rgb(231,8,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"106=
.35" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__GI___ioctl (297,545,942,=
997 samples, 57.11%)</title><rect x=3D"234.9" y=3D"693" width=3D"673.9" hei=
ght=3D"15.0" fill=3D"rgb(229,176,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"237=
.93" y=3D"703.5" >__GI___ioctl</text>=0A</g>=0A<g >=0A<title>task_tick_fair=
 (124,433,118 samples, 0.02%)</title><rect x=3D"479.7" y=3D"165" width=3D"0=
.3" height=3D"15.0" fill=3D"rgb(218,159,11)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"482.68" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>trigger_load_balan=
ce (167,451,291 samples, 0.03%)</title><rect x=3D"440.1" y=3D"229" width=3D=
"0.4" height=3D"15.0" fill=3D"rgb(210,117,47)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"443.13" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>syscall_trace_en=
ter.isra.17 (830,898,752 samples, 0.16%)</title><rect x=3D"906.9" y=3D"645"=
 width=3D"1.9" height=3D"15.0" fill=3D"rgb(246,106,15)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"909.90" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>syscall=
_return_via_sysret (3,491,626,424 samples, 0.67%)</title><rect x=3D"142.9" =
y=3D"661" width=3D"7.9" height=3D"15.0" fill=3D"rgb(231,31,2)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"145.90" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<title=
>irqtime_account_irq (166,248,643 samples, 0.03%)</title><rect x=3D"1078.1"=
 y=3D"501" width=3D"0.4" height=3D"15.0" fill=3D"rgb(211,121,39)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1081.11" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>perf_event_task_tick (202,262,693 samples, 0.04%)</title><rect x=3D"332=
.5" y=3D"261" width=3D"0.5" height=3D"15.0" fill=3D"rgb(232,65,9)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"335.53" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>hrtimer_interrupt (202,262,693 samples, 0.04%)</title><rect x=3D"332.5"=
 y=3D"357" width=3D"0.5" height=3D"15.0" fill=3D"rgb(251,199,4)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"335.53" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<titl=
e>_raw_spin_lock_irqsave (3,049,775,039 samples, 0.59%)</title><rect x=3D"9=
75.0" y=3D"581" width=3D"6.9" height=3D"15.0" fill=3D"rgb(208,185,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"977.98" y=3D"591.5" ></text>=0A</g>=0A<g >=
=0A<title>in_lock_functions (139,681,594 samples, 0.03%)</title><rect x=3D"=
691.7" y=3D"469" width=3D"0.3" height=3D"15.0" fill=3D"rgb(224,112,0)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"694.66" y=3D"479.5" ></text>=0A</g>=0A<g >=
=0A<title>native_queued_spin_lock_slowpath (747,525,394 samples, 0.14%)</ti=
tle><rect x=3D"704.5" y=3D"421" width=3D"1.7" height=3D"15.0" fill=3D"rgb(2=
16,212,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.50" y=3D"431.5" ></text>=
=0A</g>=0A<g >=0A<title>rcu_note_context_switch (754,018,930 samples, 0.14%=
)</title><rect x=3D"1133.2" y=3D"565" width=3D"1.7" height=3D"15.0" fill=3D=
"rgb(215,74,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1136.21" y=3D"575.5" ></=
text>=0A</g>=0A<g >=0A<title>psi_account_irqtime (2,742,589,553 samples, 0.=
53%)</title><rect x=3D"1135.6" y=3D"549" width=3D"6.2" height=3D"15.0" fill=
=3D"rgb(210,154,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1138.59" y=3D"559.5=
" ></text>=0A</g>=0A<g >=0A<title>__smp_call_single_queue (1,174,658,147 sa=
mples, 0.23%)</title><rect x=3D"94.4" y=3D"501" width=3D"2.6" height=3D"15.=
0" fill=3D"rgb(222,48,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"97.36" y=3D"5=
11.5" ></text>=0A</g>=0A<g >=0A<title>x2apic_send_IPI (195,771,411 samples,=
 0.04%)</title><rect x=3D"436.2" y=3D"277" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(235,42,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"439.17" y=3D"287.5=
" ></text>=0A</g>=0A<g >=0A<title>smp_call_function_many_cond (242,233,493 =
samples, 0.05%)</title><rect x=3D"1168.0" y=3D"501" width=3D"0.5" height=3D=
"15.0" fill=3D"rgb(241,207,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.00"=
 y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>native_write_msr (238,600,795 =
samples, 0.05%)</title><rect x=3D"620.1" y=3D"213" width=3D"0.6" height=3D"=
15.0" fill=3D"rgb(247,216,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"623.12" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (265,842,308 samp=
les, 0.05%)</title><rect x=3D"107.7" y=3D"453" width=3D"0.6" height=3D"15.0=
" fill=3D"rgb(214,229,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"=
463.5" ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_se (224,313,648 sa=
mples, 0.04%)</title><rect x=3D"89.8" y=3D"453" width=3D"0.5" height=3D"15.=
0" fill=3D"rgb(234,56,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"92.84" y=3D"4=
63.5" ></text>=0A</g>=0A<g >=0A<title>__vm_munmap (1,259,337,616 samples, 0=
.24%)</title><rect x=3D"1180.4" y=3D"613" width=3D"2.9" height=3D"15.0" fil=
l=3D"rgb(247,169,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"623.=
5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (979,887,867 s=
amples, 0.19%)</title><rect x=3D"477.8" y=3D"213" width=3D"2.3" height=3D"1=
5.0" fill=3D"rgb(237,134,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.84" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>clock_gettime@GLIBC_2.2.5 (1,908=
,028,842 samples, 0.37%)</title><rect x=3D"205.0" y=3D"677" width=3D"4.3" h=
eight=3D"15.0" fill=3D"rgb(235,131,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
207.95" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_zap_leafs (=
408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=3D"501" width=3D"0.=
9" height=3D"15.0" fill=3D"rgb(223,108,1)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1170.07" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault=
 (68,647,577 samples, 0.01%)</title><rect x=3D"10.3" y=3D"517" width=3D"0.2=
" height=3D"15.0" fill=3D"rgb(247,102,47)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"13.30" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__inode_security_rev=
alidate (625,608,245 samples, 0.12%)</title><rect x=3D"809.6" y=3D"597" wid=
th=3D"1.4" height=3D"15.0" fill=3D"rgb(214,178,25)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"812.62" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>preempt_cou=
nt_add (130,717,024 samples, 0.03%)</title><rect x=3D"652.3" y=3D"293" widt=
h=3D"0.3" height=3D"15.0" fill=3D"rgb(240,196,2)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"655.33" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_ca=
ll_function_single (132,942,133 samples, 0.03%)</title><rect x=3D"353.2" y=
=3D"421" width=3D"0.3" height=3D"15.0" fill=3D"rgb(247,94,5)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"356.18" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title=
>__sysvec_apic_timer_interrupt (200,976,249 samples, 0.04%)</title><rect x=
=3D"1153.0" y=3D"597" width=3D"0.4" height=3D"15.0" fill=3D"rgb(245,170,26)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1155.95" y=3D"607.5" ></text>=0A</g>=
=0A<g >=0A<title>__schedule (69,603,846,308 samples, 13.36%)</title><rect x=
=3D"984.3" y=3D"581" width=3D"157.6" height=3D"15.0" fill=3D"rgb(217,182,37=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"987.25" y=3D"591.5" >__schedule</text=
>=0A</g>=0A<g >=0A<title>__mod_zone_page_state (203,565,991 samples, 0.04%)=
</title><rect x=3D"703.6" y=3D"453" width=3D"0.5" height=3D"15.0" fill=3D"r=
gb(252,162,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"706.59" y=3D"463.5" ></te=
xt>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (420,283,529 samples, 0.08%)<=
/title><rect x=3D"476.0" y=3D"277" width=3D"1.0" height=3D"15.0" fill=3D"rg=
b(205,131,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"479.02" y=3D"287.5" ></te=
xt>=0A</g>=0A<g >=0A<title>in_lock_functions (160,897,890 samples, 0.03%)</=
title><rect x=3D"280.1" y=3D"501" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(245,187,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"283.13" y=3D"511.5" ></text=
>=0A</g>=0A<g >=0A<title>__sysvec_call_function_single (142,021,616 samples=
, 0.03%)</title><rect x=3D"288.6" y=3D"469" width=3D"0.4" height=3D"15.0" f=
ill=3D"rgb(250,121,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"291.64" y=3D"479.=
5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_single (64,445,=
321 samples, 0.01%)</title><rect x=3D"440.5" y=3D"357" width=3D"0.2" height=
=3D"15.0" fill=3D"rgb(254,44,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.51=
" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>__kvm_migrate_apic_timer (124=
,408,817 samples, 0.02%)</title><rect x=3D"260.1" y=3D"565" width=3D"0.3" h=
eight=3D"15.0" fill=3D"rgb(218,176,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
263.14" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>try_grab_folio (1,324,8=
61,115 samples, 0.25%)</title><rect x=3D"309.4" y=3D"453" width=3D"3.0" hei=
ght=3D"15.0" fill=3D"rgb(223,102,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"31=
2.37" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (2,505,5=
19,056 samples, 0.48%)</title><rect x=3D"1061.4" y=3D"533" width=3D"5.6" he=
ight=3D"15.0" fill=3D"rgb(243,4,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"106=
4.36" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled=
 (328,979,647 samples, 0.06%)</title><rect x=3D"365.2" y=3D"437" width=3D"0=
.8" height=3D"15.0" fill=3D"rgb(249,177,36)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"368.25" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (=
58,146,474,790 samples, 11.16%)</title><rect x=3D"11.2" y=3D"661" width=3D"=
131.7" height=3D"15.0" fill=3D"rgb(218,84,28)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"14.17" y=3D"671.5" >entry_SYSCALL_64</text>=0A</g>=0A<g >=0A<title>i=
rq_exit_rcu (129,373,952 samples, 0.02%)</title><rect x=3D"617.8" y=3D"213"=
 width=3D"0.3" height=3D"15.0" fill=3D"rgb(242,119,25)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"620.81" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>ttwu_do=
_activate (1,616,763,572 samples, 0.31%)</title><rect x=3D"89.0" y=3D"517" =
width=3D"3.7" height=3D"15.0" fill=3D"rgb(220,177,9)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"91.99" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>llist_rev=
erse_order (166,489,982 samples, 0.03%)</title><rect x=3D"439.3" y=3D"261" =
width=3D"0.4" height=3D"15.0" fill=3D"rgb(252,66,18)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"442.30" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>preempt_=
count_add (877,981,095 samples, 0.17%)</title><rect x=3D"128.2" y=3D"565" w=
idth=3D"2.0" height=3D"15.0" fill=3D"rgb(243,229,51)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"131.18" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>cpuacct_=
charge (302,968,247 samples, 0.06%)</title><rect x=3D"1020.1" y=3D"517" wid=
th=3D"0.7" height=3D"15.0" fill=3D"rgb(254,220,27)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1023.12" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_=
lock_irqsave (503,340,687 samples, 0.10%)</title><rect x=3D"969.2" y=3D"581=
" width=3D"1.1" height=3D"15.0" fill=3D"rgb(207,67,32)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"972.19" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>tdp_mmu=
_zap_leafs (408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=3D"485"=
 width=3D"0.9" height=3D"15.0" fill=3D"rgb(218,198,34)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"1170.07" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>__wake=
_up_common (36,091,545,589 samples, 6.93%)</title><rect x=3D"21.6" y=3D"565=
" width=3D"81.8" height=3D"15.0" fill=3D"rgb(211,8,7)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"24.61" y=3D"575.5" >__wake_up..</text>=0A</g>=0A<g >=0A<titl=
e>load_balance (2,481,291,154 samples, 0.48%)</title><rect x=3D"1090.1" y=
=3D"533" width=3D"5.6" height=3D"15.0" fill=3D"rgb(227,71,46)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1093.13" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<titl=
e>run_rebalance_domains (219,805,393 samples, 0.04%)</title><rect x=3D"970.=
9" y=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(246,77,9)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"973.94" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__hrtimer_run_queues (58,323,375 samples, 0.01%)</title><rect x=3D"439.1=
" y=3D"261" width=3D"0.1" height=3D"15.0" fill=3D"rgb(218,47,22)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"442.11" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__hrtimer_run_queues (1,030,990,007 samples, 0.20%)</title><rect x=3D"47=
7.7" y=3D"245" width=3D"2.4" height=3D"15.0" fill=3D"rgb(225,57,29)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"480.72" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<=
title>newidle_balance (6,325,896,212 samples, 1.21%)</title><rect x=3D"1084=
.9" y=3D"549" width=3D"14.3" height=3D"15.0" fill=3D"rgb(237,65,4)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"1087.89" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<=
title>task_tick_fair (162,867,555 samples, 0.03%)</title><rect x=3D"617.4" =
y=3D"101" width=3D"0.4" height=3D"15.0" fill=3D"rgb(244,61,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"620.44" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title=
>vcpu_enter_guest (243,275,747,672 samples, 46.69%)</title><rect x=3D"255.1=
" y=3D"597" width=3D"550.9" height=3D"15.0" fill=3D"rgb(224,201,7)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"258.09" y=3D"607.5" >vcpu_enter_guest</text>=0A=
</g>=0A<g >=0A<title>__cond_resched_rwlock_write (95,928,137 samples, 0.02%=
)</title><rect x=3D"806.0" y=3D"437" width=3D"0.3" height=3D"15.0" fill=3D"=
rgb(216,212,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"447.5" ></=
text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (151,196,233 samples=
, 0.03%)</title><rect x=3D"919.5" y=3D"581" width=3D"0.3" height=3D"15.0" f=
ill=3D"rgb(247,195,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"591.=
5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (314,832,357 samples, =
0.06%)</title><rect x=3D"1100.7" y=3D"533" width=3D"0.7" height=3D"15.0" fi=
ll=3D"rgb(243,87,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1103.70" y=3D"543.=
5" ></text>=0A</g>=0A<g >=0A<title>__mod_node_page_state (76,657,861 sample=
s, 0.01%)</title><rect x=3D"701.7" y=3D"437" width=3D"0.1" height=3D"15.0" =
fill=3D"rgb(246,148,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"704.66" y=3D"44=
7.5" ></text>=0A</g>=0A<g >=0A<title>asm_common_interrupt (147,822,297 samp=
les, 0.03%)</title><rect x=3D"477.3" y=3D"309" width=3D"0.3" height=3D"15.0=
" fill=3D"rgb(231,82,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"3=
19.5" ></text>=0A</g>=0A<g >=0A<title>irq_work_tick (182,843,467 samples, 0=
.04%)</title><rect x=3D"1070.3" y=3D"421" width=3D"0.4" height=3D"15.0" fil=
l=3D"rgb(231,86,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.28" y=3D"431.5=
" ></text>=0A</g>=0A<g >=0A<title>__vmx_complete_interrupts (696,920,222 sa=
mples, 0.13%)</title><rect x=3D"799.6" y=3D"565" width=3D"1.5" height=3D"15=
.0" fill=3D"rgb(236,227,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"802.56" y=
=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__loaded_vmcs_clear (132,942,133=
 samples, 0.03%)</title><rect x=3D"353.2" y=3D"357" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(238,40,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"356.18" y=
=3D"367.5" ></text>=0A</g>=0A<g >=0A<title>flush_tlb_mm_range (242,233,493 =
samples, 0.05%)</title><rect x=3D"1168.0" y=3D"533" width=3D"0.5" height=3D=
"15.0" fill=3D"rgb(234,226,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.00"=
 y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>restore_fpregs_from_fpstate (5=
76,803,240 samples, 0.11%)</title><rect x=3D"1165.8" y=3D"597" width=3D"1.3=
" height=3D"15.0" fill=3D"rgb(209,228,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1168.77" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>psi_task_switch (4=
,682,377,042 samples, 0.90%)</title><rect x=3D"640.1" y=3D"325" width=3D"10=
.6" height=3D"15.0" fill=3D"rgb(221,111,1)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"643.13" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1=
87,249,711 samples, 0.04%)</title><rect x=3D"636.1" y=3D"261" width=3D"0.4"=
 height=3D"15.0" fill=3D"rgb(226,73,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
639.09" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>irqtime_account_process=
_tick (253,982,572 samples, 0.05%)</title><rect x=3D"477.9" y=3D"181" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(229,152,40)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"480.89" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count=
_add (248,236,261 samples, 0.05%)</title><rect x=3D"187.0" y=3D"565" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(225,64,27)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"190.01" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__flush_smp_ca=
ll_function_queue (132,942,133 samples, 0.03%)</title><rect x=3D"353.2" y=
=3D"373" width=3D"0.3" height=3D"15.0" fill=3D"rgb(229,45,54)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"356.18" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title=
>try_to_wake_up (14,225,172,394 samples, 2.73%)</title><rect x=3D"405.2" y=
=3D"309" width=3D"32.2" height=3D"15.0" fill=3D"rgb(215,23,0)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"408.20" y=3D"319.5" >tr..</text>=0A</g>=0A<g >=0A<t=
itle>__list_del_entry_valid (495,189,657 samples, 0.10%)</title><rect x=3D"=
1006.5" y=3D"533" width=3D"1.1" height=3D"15.0" fill=3D"rgb(253,123,52)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1009.53" y=3D"543.5" ></text>=0A</g>=0A<g =
>=0A<title>hrtimer_interrupt (3,434,827,045 samples, 0.66%)</title><rect x=
=3D"1070.2" y=3D"501" width=3D"7.8" height=3D"15.0" fill=3D"rgb(214,19,19)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.21" y=3D"511.5" ></text>=0A</g>=0A=
<g >=0A<title>asm_sysvec_apic_timer_interrupt (1,017,883,970 samples, 0.20%=
)</title><rect x=3D"615.8" y=3D"245" width=3D"2.3" height=3D"15.0" fill=3D"=
rgb(234,178,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.80" y=3D"255.5" ></=
text>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (189,168,427 samples, 0.04%=
)</title><rect x=3D"1070.7" y=3D"373" width=3D"0.4" height=3D"15.0" fill=3D=
"rgb(211,227,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.70" y=3D"383.5" >=
</text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl_run (82,977,526 samples,=
 0.02%)</title><rect x=3D"10.3" y=3D"581" width=3D"0.2" height=3D"15.0" fil=
l=3D"rgb(254,71,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"591.5" >=
</text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (202,262,693 sam=
ples, 0.04%)</title><rect x=3D"332.5" y=3D"389" width=3D"0.5" height=3D"15.=
0" fill=3D"rgb(243,9,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"3=
99.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (368,669,73=
2 samples, 0.07%)</title><rect x=3D"702.8" y=3D"437" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(222,118,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"705.7=
6" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>vmx_get_mt_mask (393,787,524=
 samples, 0.08%)</title><rect x=3D"727.0" y=3D"501" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(226,7,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"729.96" y=
=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>vma_is_secretmem (151,386,455 sa=
mples, 0.03%)</title><rect x=3D"319.9" y=3D"453" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(252,170,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"322.87" y=
=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (110,691,527 samples, =
0.02%)</title><rect x=3D"10.0" y=3D"629" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(216,217,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"639.5" =
></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_irq (116,714,459 samples, =
0.02%)</title><rect x=3D"188.1" y=3D"581" width=3D"0.2" height=3D"15.0" fil=
l=3D"rgb(234,191,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"191.07" y=3D"591.5"=
 ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (221,070,584 samples, 0.=
04%)</title><rect x=3D"1131.6" y=3D"533" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(230,31,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1134.62" y=3D"543.5"=
 ></text>=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq (591,143,267 samp=
les, 0.11%)</title><rect x=3D"461.7" y=3D"277" width=3D"1.4" height=3D"15.0=
" fill=3D"rgb(252,20,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"464.73" y=3D"2=
87.5" ></text>=0A</g>=0A<g >=0A<title>folio_batch_move_lru (3,719,885,997 s=
amples, 0.71%)</title><rect x=3D"697.9" y=3D"485" width=3D"8.4" height=3D"1=
5.0" fill=3D"rgb(214,205,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"700.89" y=
=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (1,006,840,344 =
samples, 0.19%)</title><rect x=3D"477.8" y=3D"229" width=3D"2.3" height=3D"=
15.0" fill=3D"rgb(248,63,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.78" y=
=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (45,175,414 samp=
les, 0.01%)</title><rect x=3D"431.3" y=3D"245" width=3D"0.1" height=3D"15.0=
" fill=3D"rgb(243,195,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434.32" y=3D"=
255.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_call_function (151,189,230 =
samples, 0.03%)</title><rect x=3D"265.9" y=3D"533" width=3D"0.3" height=3D"=
15.0" fill=3D"rgb(247,26,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"268.87" y=
=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>kvm_release_page_clean (9,214,29=
8,776 samples, 1.77%)</title><rect x=3D"694.3" y=3D"533" width=3D"20.9" hei=
ght=3D"15.0" fill=3D"rgb(221,215,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"69=
7.34" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (346,04=
6,836 samples, 0.07%)</title><rect x=3D"354.5" y=3D"437" width=3D"0.8" heig=
ht=3D"15.0" fill=3D"rgb(225,68,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"357.=
51" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>rcu_qs (315,120,784 samples=
, 0.06%)</title><rect x=3D"1134.2" y=3D"549" width=3D"0.7" height=3D"15.0" =
fill=3D"rgb(214,166,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1137.20" y=3D"55=
9.5" ></text>=0A</g>=0A<g >=0A<title>__pollwait (1,394,798,582 samples, 0.2=
7%)</title><rect x=3D"1147.4" y=3D"597" width=3D"3.2" height=3D"15.0" fill=
=3D"rgb(251,125,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1150.40" y=3D"607.5=
" ></text>=0A</g>=0A<g >=0A<title>task_tick_fair (348,811,329 samples, 0.07=
%)</title><rect x=3D"1075.5" y=3D"405" width=3D"0.8" height=3D"15.0" fill=
=3D"rgb(215,37,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1078.46" y=3D"415.5"=
 ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (1,143,450,636 samples, =
0.22%)</title><rect x=3D"979.3" y=3D"565" width=3D"2.6" height=3D"15.0" fil=
l=3D"rgb(246,220,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"982.30" y=3D"575.5=
" ></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (142,628,5=
12 samples, 0.03%)</title><rect x=3D"919.5" y=3D"517" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(220,219,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.50=
" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>make_spte (2,183,733,964 samp=
les, 0.42%)</title><rect x=3D"722.9" y=3D"517" width=3D"5.0" height=3D"15.0=
" fill=3D"rgb(218,75,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"725.91" y=3D"5=
27.5" ></text>=0A</g>=0A<g >=0A<title>userfaultfd_ioctl (40,458,995,500 sam=
ples, 7.77%)</title><rect x=3D"815.3" y=3D"629" width=3D"91.6" height=3D"15=
.0" fill=3D"rgb(212,214,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"818.27" y=3D=
"639.5" >userfaultf..</text>=0A</g>=0A<g >=0A<title>scheduler_tick (58,323,=
375 samples, 0.01%)</title><rect x=3D"439.1" y=3D"197" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(254,169,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.11=
" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>ip_sublist_rcv (147,822,297 s=
amples, 0.03%)</title><rect x=3D"477.3" y=3D"133" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(230,225,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=
=3D"143.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (1,1=
08,856,987 samples, 0.21%)</title><rect x=3D"477.7" y=3D"293" width=3D"2.5"=
 height=3D"15.0" fill=3D"rgb(235,176,50)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"480.68" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_di=
sabled (1,299,903,119 samples, 0.25%)</title><rect x=3D"1162.8" y=3D"597" w=
idth=3D"3.0" height=3D"15.0" fill=3D"rgb(225,109,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1165.82" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>__libc_=
read (22,340,263,740 samples, 4.29%)</title><rect x=3D"150.8" y=3D"677" wid=
th=3D"50.6" height=3D"15.0" fill=3D"rgb(247,99,41)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"153.81" y=3D"687.5" >__lib..</text>=0A</g>=0A<g >=0A<title>[kvm=
-intel.ko] (108,885,455 samples, 0.02%)</title><rect x=3D"792.8" y=3D"533" =
width=3D"0.2" height=3D"15.0" fill=3D"rgb(233,154,27)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"795.75" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>availabl=
e_idle_cpu (1,154,399,504 samples, 0.22%)</title><rect x=3D"421.1" y=3D"277=
" width=3D"2.6" height=3D"15.0" fill=3D"rgb(237,199,9)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"424.07" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>release=
_pages (423,998,182 samples, 0.08%)</title><rect x=3D"1179.0" y=3D"469" wid=
th=3D"1.0" height=3D"15.0" fill=3D"rgb(213,211,25)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1181.99" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>update_min=
_vruntime (213,830,569 samples, 0.04%)</title><rect x=3D"1035.0" y=3D"533" =
width=3D"0.5" height=3D"15.0" fill=3D"rgb(207,82,4)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1038.02" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>send_ca=
ll_function_single_ipi (53,965,791 samples, 0.01%)</title><rect x=3D"620.7"=
 y=3D"229" width=3D"0.1" height=3D"15.0" fill=3D"rgb(235,91,43)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"623.66" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<titl=
e>_raw_spin_rq_lock_irqsave (219,805,393 samples, 0.04%)</title><rect x=3D"=
970.9" y=3D"485" width=3D"0.5" height=3D"15.0" fill=3D"rgb(209,100,3)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"973.94" y=3D"495.5" ></text>=0A</g>=0A<g >=
=0A<title>folio_copy (149,022,958 samples, 0.03%)</title><rect x=3D"662.4" =
y=3D"357" width=3D"0.3" height=3D"15.0" fill=3D"rgb(230,185,42)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"665.41" y=3D"367.5" ></text>=0A</g>=0A<g >=0A<titl=
e>sysvec_apic_timer_interrupt (71,379,673 samples, 0.01%)</title><rect x=3D=
"439.1" y=3D"309" width=3D"0.2" height=3D"15.0" fill=3D"rgb(208,115,16)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"442.11" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_tdp_mmu_zap_leafs (133,589,906 samples, 0.03%)</title><rect x=
=3D"806.0" y=3D"469" width=3D"0.3" height=3D"15.0" fill=3D"rgb(228,15,12)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"479.5" ></text>=0A</g>=0A<g=
 >=0A<title>asm_sysvec_apic_timer_interrupt (182,704,004 samples, 0.04%)</t=
itle><rect x=3D"185.1" y=3D"549" width=3D"0.4" height=3D"15.0" fill=3D"rgb(=
206,160,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.10" y=3D"559.5" ></text=
>=0A</g>=0A<g >=0A<title>update_blocked_averages (1,042,981,303 samples, 0.=
20%)</title><rect x=3D"1096.9" y=3D"533" width=3D"2.3" height=3D"15.0" fill=
=3D"rgb(225,122,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1099.86" y=3D"543.5=
" ></text>=0A</g>=0A<g >=0A<title>xas_descend (1,163,791,974 samples, 0.22%=
)</title><rect x=3D"903.6" y=3D"533" width=3D"2.6" height=3D"15.0" fill=3D"=
rgb(249,209,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"906.57" y=3D"543.5" ></=
text>=0A</g>=0A<g >=0A<title>native_sched_clock (682,433,610 samples, 0.13%=
)</title><rect x=3D"1140.3" y=3D"517" width=3D"1.5" height=3D"15.0" fill=3D=
"rgb(237,47,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1143.26" y=3D"527.5" ><=
/text>=0A</g>=0A<g >=0A<title>sysvec_call_function_single (729,972,274 samp=
les, 0.14%)</title><rect x=3D"480.8" y=3D"293" width=3D"1.6" height=3D"15.0=
" fill=3D"rgb(224,173,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"483.80" y=3D"=
303.5" ></text>=0A</g>=0A<g >=0A<title>folio_activate_fn (2,281,922,626 sam=
ples, 0.44%)</title><rect x=3D"698.9" y=3D"469" width=3D"5.2" height=3D"15.=
0" fill=3D"rgb(249,74,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"701.94" y=3D"4=
79.5" ></text>=0A</g>=0A<g >=0A<title>ip_list_rcv (147,822,297 samples, 0.0=
3%)</title><rect x=3D"477.3" y=3D"149" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(215,78,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"159.5" =
></text>=0A</g>=0A<g >=0A<title>sysvec_call_function_single (148,612,585 sa=
mples, 0.03%)</title><rect x=3D"448.9" y=3D"309" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(205,108,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"451.86" y=3D=
"319.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (218,416,971 sample=
s, 0.04%)</title><rect x=3D"1098.2" y=3D"517" width=3D"0.5" height=3D"15.0"=
 fill=3D"rgb(213,130,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1101.23" y=3D"5=
27.5" ></text>=0A</g>=0A<g >=0A<title>_find_next_bit (1,060,403,016 samples=
, 0.20%)</title><rect x=3D"61.0" y=3D"501" width=3D"2.4" height=3D"15.0" fi=
ll=3D"rgb(215,1,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.98" y=3D"511.5" =
></text>=0A</g>=0A<g >=0A<title>enqueue_entity (73,060,463 samples, 0.01%)<=
/title><rect x=3D"431.3" y=3D"261" width=3D"0.1" height=3D"15.0" fill=3D"rg=
b(247,216,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434.26" y=3D"271.5" ></te=
xt>=0A</g>=0A<g >=0A<title>copy_user_enhanced_fast_string (48,997,742 sampl=
es, 0.01%)</title><rect x=3D"837.5" y=3D"597" width=3D"0.1" height=3D"15.0"=
 fill=3D"rgb(212,147,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"840.49" y=3D"6=
07.5" ></text>=0A</g>=0A<g >=0A<title>entry_SYSCALL_64 (292,043,195,368 sam=
ples, 56.05%)</title><rect x=3D"247.4" y=3D"677" width=3D"661.4" height=3D"=
15.0" fill=3D"rgb(217,101,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"250.39" y=
=3D"687.5" >entry_SYSCALL_64</text>=0A</g>=0A<g >=0A<title>__rcu_read_lock =
(155,124,488 samples, 0.03%)</title><rect x=3D"639.0" y=3D"277" width=3D"0.=
4" height=3D"15.0" fill=3D"rgb(205,45,31)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"642.04" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queue=
s (2,946,246,677 samples, 0.57%)</title><rect x=3D"1070.2" y=3D"485" width=
=3D"6.7" height=3D"15.0" fill=3D"rgb(213,145,1)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1073.21" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_ta=
sk_tick (517,389,867 samples, 0.10%)</title><rect x=3D"478.5" y=3D"165" wid=
th=3D"1.2" height=3D"15.0" fill=3D"rgb(229,196,1)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"481.50" y=3D"175.5" ></text>=0A</g>=0A<g >=0A<title>put_prev_ent=
ity (362,883,917 samples, 0.07%)</title><rect x=3D"1099.2" y=3D"549" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(212,186,51)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1102.24" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>psi_account_=
irqtime (219,425,190 samples, 0.04%)</title><rect x=3D"1098.7" y=3D"501" wi=
dth=3D"0.5" height=3D"15.0" fill=3D"rgb(224,165,34)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1101.72" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>vm_norm=
al_page (44,231,737 samples, 0.01%)</title><rect x=3D"1183.2" y=3D"517" wid=
th=3D"0.1" height=3D"15.0" fill=3D"rgb(238,60,9)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1186.16" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__get_user_p=
ages (155,626,682,649 samples, 29.87%)</title><rect x=3D"313.7" y=3D"485" w=
idth=3D"352.4" height=3D"15.0" fill=3D"rgb(215,221,49)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"316.66" y=3D"495.5" >__get_user_pages</text>=0A</g>=0A<g >=
=0A<title>asm_sysvec_apic_timer_interrupt (192,863,815 samples, 0.04%)</tit=
le><rect x=3D"440.1" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(21=
0,133,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.07" y=3D"367.5" ></text>=
=0A</g>=0A<g >=0A<title>task_work_run (46,889,230 samples, 0.01%)</title><r=
ect x=3D"141.5" y=3D"597" width=3D"0.1" height=3D"15.0" fill=3D"rgb(240,211=
,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.49" y=3D"607.5" ></text>=0A</g=
>=0A<g >=0A<title>userfaultfd_ctx_put (551,797,647 samples, 0.11%)</title><=
rect x=3D"661.1" y=3D"357" width=3D"1.3" height=3D"15.0" fill=3D"rgb(240,70=
,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"664.12" y=3D"367.5" ></text>=0A</g=
>=0A<g >=0A<title>folio_mark_dirty (44,324,072 samples, 0.01%)</title><rect=
 x=3D"1181.9" y=3D"517" width=3D"0.1" height=3D"15.0" fill=3D"rgb(241,45,23=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1184.94" y=3D"527.5" ></text>=0A</g>=
=0A<g >=0A<title>__mod_lruvec_page_state (44,430,129 samples, 0.01%)</title=
><rect x=3D"1180.2" y=3D"421" width=3D"0.1" height=3D"15.0" fill=3D"rgb(242=
,83,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.16" y=3D"431.5" ></text>=0A=
</g>=0A<g >=0A<title>__loaded_vmcs_clear (453,881,056 samples, 0.09%)</titl=
e><rect x=3D"1080.2" y=3D"485" width=3D"1.0" height=3D"15.0" fill=3D"rgb(23=
7,194,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1083.16" y=3D"495.5" ></text>=
=0A</g>=0A<g >=0A<title>page_add_file_rmap (798,653,534 samples, 0.15%)</ti=
tle><rect x=3D"877.0" y=3D"581" width=3D"1.8" height=3D"15.0" fill=3D"rgb(2=
10,86,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"880.00" y=3D"591.5" ></text>=
=0A</g>=0A<g >=0A<title>vfs_read (11,760,461,595 samples, 2.26%)</title><re=
ct x=3D"166.0" y=3D"613" width=3D"26.6" height=3D"15.0" fill=3D"rgb(228,229=
,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"169.01" y=3D"623.5" >v..</text>=0A=
</g>=0A<g >=0A<title>_raw_spin_lock (254,823,357 samples, 0.05%)</title><re=
ct x=3D"1095.7" y=3D"517" width=3D"0.6" height=3D"15.0" fill=3D"rgb(221,11,=
31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1098.75" y=3D"527.5" ></text>=0A</g=
>=0A<g >=0A<title>sysvec_apic_timer_interrupt (151,196,233 samples, 0.03%)<=
/title><rect x=3D"919.5" y=3D"661" width=3D"0.3" height=3D"15.0" fill=3D"rg=
b(228,81,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"671.5" ></tex=
t>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (1,899,534,991 sam=
ples, 0.36%)</title><rect x=3D"1071.1" y=3D"389" width=3D"4.3" height=3D"15=
.0" fill=3D"rgb(221,199,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1074.13" y=
=3D"399.5" ></text>=0A</g>=0A<g >=0A<title>__loaded_vmcs_clear (45,175,111 =
samples, 0.01%)</title><rect x=3D"440.5" y=3D"293" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(227,134,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.51" y=
=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__calc_delta (108,413,298 sample=
s, 0.02%)</title><rect x=3D"456.4" y=3D"277" width=3D"0.3" height=3D"15.0" =
fill=3D"rgb(239,63,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"459.43" y=3D"287=
.5" ></text>=0A</g>=0A<g >=0A<title>__do_softirq (119,334,805 samples, 0.02=
%)</title><rect x=3D"617.8" y=3D"197" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(243,147,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"620.81" y=3D"207.5" ><=
/text>=0A</g>=0A<g >=0A<title>perf_pmu_disable (388,828,223 samples, 0.07%)=
</title><rect x=3D"447.8" y=3D"309" width=3D"0.8" height=3D"15.0" fill=3D"r=
gb(236,8,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"450.76" y=3D"319.5" ></tex=
t>=0A</g>=0A<g >=0A<title>preempt_count_sub (87,791,100 samples, 0.02%)</ti=
tle><rect x=3D"477.0" y=3D"277" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
20,78,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"479.98" y=3D"287.5" ></text>=
=0A</g>=0A<g >=0A<title>ioctl_has_perm.constprop.59 (3,435,252,875 samples,=
 0.66%)</title><rect x=3D"806.9" y=3D"613" width=3D"7.8" height=3D"15.0" fi=
ll=3D"rgb(226,60,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.89" y=3D"623.5=
" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_single (217,054,=
399 samples, 0.04%)</title><rect x=3D"618.1" y=3D"245" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(239,29,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"621.11"=
 y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (169=
,190,013 samples, 0.03%)</title><rect x=3D"697.1" y=3D"485" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(206,87,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"7=
00.14" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>copy_user_short_string (=
53,325,810 samples, 0.01%)</title><rect x=3D"837.6" y=3D"597" width=3D"0.1"=
 height=3D"15.0" fill=3D"rgb(217,83,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
840.60" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_munmap (1,259=
,337,616 samples, 0.24%)</title><rect x=3D"1180.4" y=3D"629" width=3D"2.9" =
height=3D"15.0" fill=3D"rgb(214,112,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1183.41" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disa=
bled (294,431,959 samples, 0.06%)</title><rect x=3D"423.7" y=3D"277" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(218,71,49)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"426.69" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__list_add_val=
id (179,997,670 samples, 0.03%)</title><rect x=3D"701.2" y=3D"453" width=3D=
"0.4" height=3D"15.0" fill=3D"rgb(219,38,23)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"704.17" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__schedule (94,57=
2,477,899 samples, 18.15%)</title><rect x=3D"442.4" y=3D"341" width=3D"214.=
2" height=3D"15.0" fill=3D"rgb(217,158,48)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"445.37" y=3D"351.5" >__schedule</text>=0A</g>=0A<g >=0A<title>__intel_p=
mu_enable_all.constprop.49 (1,496,603,235 samples, 0.29%)</title><rect x=3D=
"1057.4" y=3D"533" width=3D"3.4" height=3D"15.0" fill=3D"rgb(236,85,34)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1060.37" y=3D"543.5" ></text>=0A</g>=0A<g =
>=0A<title>sched_clock_cpu (682,433,610 samples, 0.13%)</title><rect x=3D"1=
140.3" y=3D"533" width=3D"1.5" height=3D"15.0" fill=3D"rgb(254,197,0)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1143.26" y=3D"543.5" ></text>=0A</g>=0A<g =
>=0A<title>unmap_region (1,259,337,616 samples, 0.24%)</title><rect x=3D"11=
80.4" y=3D"565" width=3D"2.9" height=3D"15.0" fill=3D"rgb(216,39,0)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"575.5" ></text>=0A</g>=0A<g >=0A=
<title>__update_load_avg_se (474,931,429 samples, 0.09%)</title><rect x=3D"=
463.1" y=3D"277" width=3D"1.0" height=3D"15.0" fill=3D"rgb(222,214,25)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"466.07" y=3D"287.5" ></text>=0A</g>=0A<g >=
=0A<title>ttwu_queue_wakelist (1,908,958,319 samples, 0.37%)</title><rect x=
=3D"432.3" y=3D"293" width=3D"4.3" height=3D"15.0" fill=3D"rgb(224,110,39)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"435.29" y=3D"303.5" ></text>=0A</g>=0A<=
g >=0A<title>psi_group_change (3,837,719,871 samples, 0.74%)</title><rect x=
=3D"640.6" y=3D"309" width=3D"8.7" height=3D"15.0" fill=3D"rgb(232,126,29)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"643.61" y=3D"319.5" ></text>=0A</g>=0A<=
g >=0A<title>_raw_spin_unlock_irqrestore (582,959,278 samples, 0.11%)</titl=
e><rect x=3D"188.3" y=3D"581" width=3D"1.4" height=3D"15.0" fill=3D"rgb(234=
,136,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"191.34" y=3D"591.5" ></text>=0A=
</g>=0A<g >=0A<title>update_sd_lb_stats.constprop.137 (945,950,757 samples,=
 0.18%)</title><rect x=3D"1092.3" y=3D"501" width=3D"2.1" height=3D"15.0" f=
ill=3D"rgb(252,15,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1095.27" y=3D"511=
.5" ></text>=0A</g>=0A<g >=0A<title>__poll (116,829,139,330 samples, 22.42%=
)</title><rect x=3D"914.4" y=3D"693" width=3D"264.6" height=3D"15.0" fill=
=3D"rgb(232,123,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"917.40" y=3D"703.5"=
 >__poll</text>=0A</g>=0A<g >=0A<title>fast_page_fault (347,945,525 samples=
, 0.07%)</title><rect x=3D"284.0" y=3D"533" width=3D"0.8" height=3D"15.0" f=
ill=3D"rgb(213,88,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"287.00" y=3D"543.=
5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_call_function_single (258,005,6=
54 samples, 0.05%)</title><rect x=3D"164.6" y=3D"533" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(251,90,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.56=
" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>llist_add_batch (620,536,872 =
samples, 0.12%)</title><rect x=3D"618.7" y=3D"213" width=3D"1.4" height=3D"=
15.0" fill=3D"rgb(245,49,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"621.68" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>_find_next_bit (296,633,039 samp=
les, 0.06%)</title><rect x=3D"639.4" y=3D"277" width=3D"0.7" height=3D"15.0=
" fill=3D"rgb(238,85,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"642.39" y=3D"2=
87.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slowpath (187=
,249,711 samples, 0.04%)</title><rect x=3D"636.1" y=3D"245" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(214,142,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
639.09" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>fire_user_return_notifi=
ers (1,828,695,525 samples, 0.35%)</title><rect x=3D"1154.9" y=3D"613" widt=
h=3D"4.1" height=3D"15.0" fill=3D"rgb(218,224,35)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1157.90" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_ap=
ic_timer_interrupt (1,054,629,472 samples, 0.20%)</title><rect x=3D"477.7" =
y=3D"277" width=3D"2.4" height=3D"15.0" fill=3D"rgb(251,125,17)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"480.68" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<titl=
e>add_atomic_switch_msr.constprop.115 (272,841,894 samples, 0.05%)</title><=
rect x=3D"802.4" y=3D"565" width=3D"0.6" height=3D"15.0" fill=3D"rgb(246,16=
2,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"805.41" y=3D"575.5" ></text>=0A</=
g>=0A<g >=0A<title>fib_validate_source (147,822,297 samples, 0.03%)</title>=
<rect x=3D"477.3" y=3D"69" width=3D"0.3" height=3D"15.0" fill=3D"rgb(217,13=
,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"79.5" ></text>=0A</g>=
=0A<g >=0A<title>task_work_run (650,309,023 samples, 0.12%)</title><rect x=
=3D"1167.1" y=3D"613" width=3D"1.4" height=3D"15.0" fill=3D"rgb(254,90,2)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.07" y=3D"623.5" ></text>=0A</g>=0A<=
g >=0A<title>change_prot_numa (143,136,218 samples, 0.03%)</title><rect x=
=3D"806.0" y=3D"549" width=3D"0.4" height=3D"15.0" fill=3D"rgb(239,140,49)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"559.5" ></text>=0A</g>=0A<=
g >=0A<title>asm_sysvec_apic_timer_interrupt (169,186,897 samples, 0.03%)</=
title><rect x=3D"494.0" y=3D"261" width=3D"0.4" height=3D"15.0" fill=3D"rgb=
(215,91,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"497.00" y=3D"271.5" ></text=
>=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq (1,475,452,070 samples, 0=
.28%)</title><rect x=3D"1027.9" y=3D"517" width=3D"3.4" height=3D"15.0" fil=
l=3D"rgb(222,21,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1030.92" y=3D"527.5=
" ></text>=0A</g>=0A<g >=0A<title>do_vmi_munmap (1,259,337,616 samples, 0.2=
4%)</title><rect x=3D"1180.4" y=3D"597" width=3D"2.9" height=3D"15.0" fill=
=3D"rgb(205,158,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"607.5=
" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (298,785,585 samples, =
0.06%)</title><rect x=3D"1067.8" y=3D"533" width=3D"0.7" height=3D"15.0" fi=
ll=3D"rgb(244,16,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1070.82" y=3D"543.=
5" ></text>=0A</g>=0A<g >=0A<title>tlb_flush_rmap_batch (425,031,408 sample=
s, 0.08%)</title><rect x=3D"1182.2" y=3D"501" width=3D"1.0" height=3D"15.0"=
 fill=3D"rgb(243,47,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.20" y=3D"5=
11.5" ></text>=0A</g>=0A<g >=0A<title>vmx_vcpu_run (25,720,316,781 samples,=
 4.94%)</title><rect x=3D"747.8" y=3D"581" width=3D"58.2" height=3D"15.0" f=
ill=3D"rgb(237,52,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"750.79" y=3D"591.=
5" >vmx_vc..</text>=0A</g>=0A<g >=0A<title>native_write_msr (871,051,498 sa=
mples, 0.17%)</title><rect x=3D"745.6" y=3D"565" width=3D"2.0" height=3D"15=
.0" fill=3D"rgb(236,228,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"748.64" y=3D=
"575.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (345,461,652=
 samples, 0.07%)</title><rect x=3D"190.2" y=3D"565" width=3D"0.8" height=3D=
"15.0" fill=3D"rgb(222,93,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"193.20" y=
=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>cpus_share_cache (231,327,943 sa=
mples, 0.04%)</title><rect x=3D"72.7" y=3D"501" width=3D"0.5" height=3D"15.=
0" fill=3D"rgb(234,225,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"75.66" y=3D"=
511.5" ></text>=0A</g>=0A<g >=0A<title>avc_has_extended_perms (1,603,101,83=
8 samples, 0.31%)</title><rect x=3D"811.0" y=3D"597" width=3D"3.7" height=
=3D"15.0" fill=3D"rgb(243,50,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"814.04=
" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_group (113,022,053=
 samples, 0.02%)</title><rect x=3D"479.7" y=3D"149" width=3D"0.2" height=3D=
"15.0" fill=3D"rgb(212,22,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"482.68" y=
=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>__calc_delta (1,568,887,284 samp=
les, 0.30%)</title><rect x=3D"1014.3" y=3D"517" width=3D"3.6" height=3D"15.=
0" fill=3D"rgb(207,145,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1017.33" y=
=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__cond_resched (286,294,502 samp=
les, 0.05%)</title><rect x=3D"854.4" y=3D"581" width=3D"0.6" height=3D"15.0=
" fill=3D"rgb(222,178,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"857.39" y=3D"5=
91.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_notifier_invalidate_range_sta=
rt (408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=3D"533" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(219,1,26)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"1170.07" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_tas=
k_tick (2,092,306,090 samples, 0.40%)</title><rect x=3D"1070.7" y=3D"405" w=
idth=3D"4.7" height=3D"15.0" fill=3D"rgb(218,103,31)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1073.69" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_=
spin_lock (203,477,680 samples, 0.04%)</title><rect x=3D"107.3" y=3D"581" w=
idth=3D"0.4" height=3D"15.0" fill=3D"rgb(234,37,14)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"110.26" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>gup_pgd_=
range (8,322,074,970 samples, 1.60%)</title><rect x=3D"293.5" y=3D"469" wid=
th=3D"18.9" height=3D"15.0" fill=3D"rgb(228,111,18)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"296.53" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>tlb_flus=
h_rmaps (425,031,408 samples, 0.08%)</title><rect x=3D"1182.2" y=3D"517" wi=
dth=3D"1.0" height=3D"15.0" fill=3D"rgb(251,120,41)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1185.20" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>check_p=
reemption_disabled (366,157,265 samples, 0.07%)</title><rect x=3D"997.9" y=
=3D"533" width=3D"0.8" height=3D"15.0" fill=3D"rgb(229,14,39)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1000.90" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__dentry_kill (625,495,838 samples, 0.12%)</title><rect x=3D"1179.0" y=3D=
"565" width=3D"1.4" height=3D"15.0" fill=3D"rgb(231,137,14)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1181.99" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>a=
sm_sysvec_apic_timer_interrupt (71,379,673 samples, 0.01%)</title><rect x=
=3D"439.1" y=3D"325" width=3D"0.2" height=3D"15.0" fill=3D"rgb(217,215,45)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.11" y=3D"335.5" ></text>=0A</g>=0A<=
g >=0A<title>preempt_count_add (633,815,170 samples, 0.12%)</title><rect x=
=3D"870.9" y=3D"565" width=3D"1.4" height=3D"15.0" fill=3D"rgb(220,140,20)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"873.87" y=3D"575.5" ></text>=0A</g>=0A<=
g >=0A<title>preempt_count_add (535,963,340 samples, 0.10%)</title><rect x=
=3D"32.8" y=3D"501" width=3D"1.2" height=3D"15.0" fill=3D"rgb(224,217,18)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"35.80" y=3D"511.5" ></text>=0A</g>=0A<g =
>=0A<title>__flush_smp_call_function_queue (151,189,230 samples, 0.03%)</ti=
tle><rect x=3D"265.9" y=3D"517" width=3D"0.3" height=3D"15.0" fill=3D"rgb(2=
23,94,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"268.87" y=3D"527.5" ></text>=
=0A</g>=0A<g >=0A<title>_find_next_and_bit (143,506,532 samples, 0.03%)</ti=
tle><rect x=3D"635.4" y=3D"245" width=3D"0.3" height=3D"15.0" fill=3D"rgb(2=
28,104,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"638.42" y=3D"255.5" ></text>=
=0A</g>=0A<g >=0A<title>sched_clock_cpu (174,335,770 samples, 0.03%)</title=
><rect x=3D"656.1" y=3D"309" width=3D"0.4" height=3D"15.0" fill=3D"rgb(220,=
42,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"659.10" y=3D"319.5" ></text>=0A</=
g>=0A<g >=0A<title>userfaultfd_poll (4,320,743,686 samples, 0.83%)</title><=
rect x=3D"1143.2" y=3D"613" width=3D"9.8" height=3D"15.0" fill=3D"rgb(249,1=
1,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1146.17" y=3D"623.5" ></text>=0A<=
/g>=0A<g >=0A<title>update_curr (270,461,772 samples, 0.05%)</title><rect x=
=3D"1090.8" y=3D"453" width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,79,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1093.77" y=3D"463.5" ></text>=0A</g>=0A=
<g >=0A<title>activate_task (188,276,732 samples, 0.04%)</title><rect x=3D"=
632.9" y=3D"261" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,96,46)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"635.88" y=3D"271.5" ></text>=0A</g>=0A<g >=
=0A<title>pud_pgtable (151,958,115 samples, 0.03%)</title><rect x=3D"664.4"=
 y=3D"437" width=3D"0.3" height=3D"15.0" fill=3D"rgb(242,205,10)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"667.40" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<tit=
le>entry_SYSCALL_64 (6,441,106,336 samples, 1.24%)</title><rect x=3D"210.2"=
 y=3D"661" width=3D"14.6" height=3D"15.0" fill=3D"rgb(254,31,41)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"213.17" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<tit=
le>asm_sysvec_call_function_single (2,024,489,362 samples, 0.39%)</title><r=
ect x=3D"1078.5" y=3D"549" width=3D"4.6" height=3D"15.0" fill=3D"rgb(245,30=
,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1081.48" y=3D"559.5" ></text>=0A</g=
>=0A<g >=0A<title>mm_alloc_pmd (5,182,805,779 samples, 0.99%)</title><rect =
x=3D"881.3" y=3D"597" width=3D"11.7" height=3D"15.0" fill=3D"rgb(223,88,49)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"884.30" y=3D"607.5" ></text>=0A</g>=0A=
<g >=0A<title>tdp_iter_next (1,272,099,199 samples, 0.24%)</title><rect x=
=3D"727.9" y=3D"517" width=3D"2.8" height=3D"15.0" fill=3D"rgb(245,109,35)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"730.85" y=3D"527.5" ></text>=0A</g>=0A<=
g >=0A<title>llist_reverse_order (78,567,912 samples, 0.02%)</title><rect x=
=3D"1081.2" y=3D"485" width=3D"0.2" height=3D"15.0" fill=3D"rgb(225,161,41)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1084.19" y=3D"495.5" ></text>=0A</g>=
=0A<g >=0A<title>remove_entity_load_avg (376,777,640 samples, 0.07%)</title=
><rect x=3D"430.0" y=3D"261" width=3D"0.9" height=3D"15.0" fill=3D"rgb(217,=
175,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"433.03" y=3D"271.5" ></text>=0A=
</g>=0A<g >=0A<title>xfer_to_guest_mode_handle_work (146,099,514 samples, 0=
.03%)</title><rect x=3D"806.0" y=3D"597" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(242,215,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.04" y=3D"607.5"=
 ></text>=0A</g>=0A<g >=0A<title>_copy_to_user (826,147,317 samples, 0.16%)=
</title><rect x=3D"183.6" y=3D"581" width=3D"1.9" height=3D"15.0" fill=3D"r=
gb(251,205,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"186.64" y=3D"591.5" ></t=
ext>=0A</g>=0A<g >=0A<title>preempt_count_add (452,058,709 samples, 0.09%)<=
/title><rect x=3D"691.0" y=3D"485" width=3D"1.0" height=3D"15.0" fill=3D"rg=
b(250,50,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"693.95" y=3D"495.5" ></text=
>=0A</g>=0A<g >=0A<title>task_work_run (143,136,218 samples, 0.03%)</title>=
<rect x=3D"806.0" y=3D"581" width=3D"0.4" height=3D"15.0" fill=3D"rgb(214,3=
3,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"591.5" ></text>=0A</g=
>=0A<g >=0A<title>sysvec_apic_timer_interrupt (169,186,897 samples, 0.03%)<=
/title><rect x=3D"494.0" y=3D"245" width=3D"0.4" height=3D"15.0" fill=3D"rg=
b(223,79,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"497.00" y=3D"255.5" ></tex=
t>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_single (142,021,616 samp=
les, 0.03%)</title><rect x=3D"288.6" y=3D"501" width=3D"0.4" height=3D"15.0=
" fill=3D"rgb(216,204,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"291.64" y=3D"=
511.5" ></text>=0A</g>=0A<g >=0A<title>__flush_smp_call_function_queue (142=
,021,616 samples, 0.03%)</title><rect x=3D"288.6" y=3D"453" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(238,15,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"2=
91.64" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>add_wait_queue (755,331,=
118 samples, 0.14%)</title><rect x=3D"1151.2" y=3D"597" width=3D"1.8" heigh=
t=3D"15.0" fill=3D"rgb(244,216,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1154=
.24" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (236,504=
,319 samples, 0.05%)</title><rect x=3D"1152.4" y=3D"565" width=3D"0.6" heig=
ht=3D"15.0" fill=3D"rgb(209,222,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1155=
.42" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__filemap_remove_folio (13=
2,901,856 samples, 0.03%)</title><rect x=3D"1180.0" y=3D"453" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(210,193,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1183.01" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__mod_memcg_lruvec=
_state (775,914,143 samples, 0.15%)</title><rect x=3D"701.8" y=3D"453" widt=
h=3D"1.8" height=3D"15.0" fill=3D"rgb(212,155,19)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"704.84" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>evict (625,4=
95,838 samples, 0.12%)</title><rect x=3D"1179.0" y=3D"549" width=3D"1.4" he=
ight=3D"15.0" fill=3D"rgb(241,62,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
81.99" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>queued_write_lock_slowpa=
th (95,928,137 samples, 0.02%)</title><rect x=3D"806.0" y=3D"405" width=3D"=
0.3" height=3D"15.0" fill=3D"rgb(250,77,37)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"809.05" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock =
(329,012,687 samples, 0.06%)</title><rect x=3D"220.0" y=3D"597" width=3D"0.=
8" height=3D"15.0" fill=3D"rgb(213,71,30)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"223.05" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_fun=
ction_single (179,244,397 samples, 0.03%)</title><rect x=3D"439.3" y=3D"325=
" width=3D"0.4" height=3D"15.0" fill=3D"rgb(223,29,5)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"442.27" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>syscall_=
return_via_sysret (2,960,717,450 samples, 0.57%)</title><rect x=3D"1172.3" =
y=3D"677" width=3D"6.7" height=3D"15.0" fill=3D"rgb(242,152,28)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1175.28" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<tit=
le>sched_clock_cpu (44,857,388 samples, 0.01%)</title><rect x=3D"435.6" y=
=3D"277" width=3D"0.1" height=3D"15.0" fill=3D"rgb(241,66,21)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"438.62" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title=
>preempt_count_add (580,518,607 samples, 0.11%)</title><rect x=3D"855.1" y=
=3D"581" width=3D"1.3" height=3D"15.0" fill=3D"rgb(220,110,33)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"858.10" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>__hrtimer_run_queues (202,262,693 samples, 0.04%)</title><rect x=3D"332.5"=
 y=3D"341" width=3D"0.5" height=3D"15.0" fill=3D"rgb(248,145,3)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"335.53" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<titl=
e>mtree_range_walk (2,304,185,191 samples, 0.44%)</title><rect x=3D"327.8" =
y=3D"421" width=3D"5.2" height=3D"15.0" fill=3D"rgb(225,105,21)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"330.77" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<titl=
e>llist_add_batch (1,174,658,147 samples, 0.23%)</title><rect x=3D"94.4" y=
=3D"485" width=3D"2.6" height=3D"15.0" fill=3D"rgb(219,4,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"97.36" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>=
hrtimer_interrupt (192,863,815 samples, 0.04%)</title><rect x=3D"440.1" y=
=3D"309" width=3D"0.4" height=3D"15.0" fill=3D"rgb(250,29,46)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"443.07" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title=
>asm_sysvec_apic_timer_interrupt (200,976,249 samples, 0.04%)</title><rect =
x=3D"1153.0" y=3D"629" width=3D"0.4" height=3D"15.0" fill=3D"rgb(229,144,25=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1155.95" y=3D"639.5" ></text>=0A</g>=
=0A<g >=0A<title>syscall_exit_to_user_mode (824,677,180 samples, 0.16%)</ti=
tle><rect x=3D"141.0" y=3D"629" width=3D"1.9" height=3D"15.0" fill=3D"rgb(2=
45,184,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"143.99" y=3D"639.5" ></text>=
=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (5,732,176,400 samples, 1.10%)<=
/title><rect x=3D"893.9" y=3D"581" width=3D"13.0" height=3D"15.0" fill=3D"r=
gb(206,125,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"896.92" y=3D"591.5" ></te=
xt>=0A</g>=0A<g >=0A<title>do_fault (126,577,715,636 samples, 24.29%)</titl=
e><rect x=3D"375.7" y=3D"437" width=3D"286.7" height=3D"15.0" fill=3D"rgb(2=
26,52,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"378.71" y=3D"447.5" >do_fault<=
/text>=0A</g>=0A<g >=0A<title>debug_smp_processor_id (166,248,643 samples, =
0.03%)</title><rect x=3D"1078.1" y=3D"485" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(228,109,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1081.11" y=3D"495=
.5" ></text>=0A</g>=0A<g >=0A<title>__fdget_pos (1,405,172,798 samples, 0.2=
7%)</title><rect x=3D"162.3" y=3D"613" width=3D"3.1" height=3D"15.0" fill=
=3D"rgb(211,131,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"165.25" y=3D"623.5"=
 ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (875,695,984 samples, 0.1=
7%)</title><rect x=3D"615.8" y=3D"165" width=3D"2.0" height=3D"15.0" fill=
=3D"rgb(227,116,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.83" y=3D"175.5"=
 ></text>=0A</g>=0A<g >=0A<title>kvm_set_user_return_msr (1,315,027,247 sam=
ples, 0.25%)</title><rect x=3D"742.7" y=3D"565" width=3D"2.9" height=3D"15.=
0" fill=3D"rgb(242,72,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"745.66" y=3D"=
575.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (142,628,512 sa=
mples, 0.03%)</title><rect x=3D"919.5" y=3D"533" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(242,108,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.50" y=
=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>vmx_interrupt_blocked (741,177,2=
76 samples, 0.14%)</title><rect x=3D"692.7" y=3D"485" width=3D"1.6" height=
=3D"15.0" fill=3D"rgb(236,99,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"695.66=
" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>native_flush_tlb_one_user (15=
1,189,230 samples, 0.03%)</title><rect x=3D"265.9" y=3D"485" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(229,217,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"268.87" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>in_lock_functions (421=
,925,329 samples, 0.08%)</title><rect x=3D"129.2" y=3D"549" width=3D"1.0" h=
eight=3D"15.0" fill=3D"rgb(221,105,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
132.21" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mo=
de_prepare (556,524,718 samples, 0.11%)</title><rect x=3D"141.6" y=3D"613" =
width=3D"1.3" height=3D"15.0" fill=3D"rgb(240,21,28)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"144.59" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec=
_apic_timer_interrupt (169,186,897 samples, 0.03%)</title><rect x=3D"494.0"=
 y=3D"229" width=3D"0.4" height=3D"15.0" fill=3D"rgb(253,106,41)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"497.00" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__list_add_valid (206,947,828 samples, 0.04%)</title><rect x=3D"493.5" y=
=3D"261" width=3D"0.5" height=3D"15.0" fill=3D"rgb(246,2,19)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"496.53" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title=
>preempt_count_sub (561,132,572 samples, 0.11%)</title><rect x=3D"1141.9" y=
=3D"581" width=3D"1.3" height=3D"15.0" fill=3D"rgb(231,220,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1144.90" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<titl=
e>native_sched_clock (44,857,388 samples, 0.01%)</title><rect x=3D"435.6" y=
=3D"261" width=3D"0.1" height=3D"15.0" fill=3D"rgb(244,77,29)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"438.62" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title=
>_raw_spin_unlock_irqrestore (987,705,054 samples, 0.19%)</title><rect x=3D=
"970.9" y=3D"597" width=3D"2.3" height=3D"15.0" fill=3D"rgb(206,223,35)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"973.94" y=3D"607.5" ></text>=0A</g>=0A<g >=
=0A<title>__close (625,495,838 samples, 0.12%)</title><rect x=3D"1179.0" y=
=3D"677" width=3D"1.4" height=3D"15.0" fill=3D"rgb(218,5,8)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"1181.99" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>i=
dle_cpu (154,871,093 samples, 0.03%)</title><rect x=3D"635.7" y=3D"245" wid=
th=3D"0.4" height=3D"15.0" fill=3D"rgb(237,226,16)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"638.74" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>native_queu=
ed_spin_lock_slowpath (559,804,875 samples, 0.11%)</title><rect x=3D"1094.4=
" y=3D"485" width=3D"1.3" height=3D"15.0" fill=3D"rgb(240,156,15)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1097.41" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<t=
itle>do_raw_spin_lock (2,297,937,909 samples, 0.44%)</title><rect x=3D"408.=
0" y=3D"277" width=3D"5.2" height=3D"15.0" fill=3D"rgb(217,45,49)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"410.99" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>update_process_times (192,863,815 samples, 0.04%)</title><rect x=3D"440=
.1" y=3D"245" width=3D"0.4" height=3D"15.0" fill=3D"rgb(228,151,32)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"443.07" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<=
title>mcopy_continue (30,545,342,042 samples, 5.86%)</title><rect x=3D"837.=
7" y=3D"613" width=3D"69.2" height=3D"15.0" fill=3D"rgb(237,36,48)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"840.72" y=3D"623.5" >mcopy_c..</text>=0A</g>=0A=
<g >=0A<title>ip_rcv_finish_core.isra.22 (147,822,297 samples, 0.03%)</titl=
e><rect x=3D"477.3" y=3D"117" width=3D"0.3" height=3D"15.0" fill=3D"rgb(216=
,71,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"127.5" ></text>=0A=
</g>=0A<g >=0A<title>folio_lruvec_lock_irqsave (929,291,078 samples, 0.18%)=
</title><rect x=3D"704.1" y=3D"469" width=3D"2.1" height=3D"15.0" fill=3D"r=
gb(205,203,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.11" y=3D"479.5" ></te=
xt>=0A</g>=0A<g >=0A<title>xas_start (479,529,116 samples, 0.09%)</title><r=
ect x=3D"387.2" y=3D"341" width=3D"1.1" height=3D"15.0" fill=3D"rgb(215,136=
,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"390.25" y=3D"351.5" ></text>=0A</g=
>=0A<g >=0A<title>native_sched_clock (260,047,181 samples, 0.05%)</title><r=
ect x=3D"637.7" y=3D"245" width=3D"0.6" height=3D"15.0" fill=3D"rgb(228,165=
,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"640.73" y=3D"255.5" ></text>=0A</g=
>=0A<g >=0A<title>do_raw_spin_lock (5,605,786,372 samples, 1.08%)</title><r=
ect x=3D"36.6" y=3D"501" width=3D"12.7" height=3D"15.0" fill=3D"rgb(237,170=
,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"39.56" y=3D"511.5" ></text>=0A</g>=
=0A<g >=0A<title>syscall (10,270,569,770 samples, 1.97%)</title><rect x=3D"=
209.4" y=3D"677" width=3D"23.2" height=3D"15.0" fill=3D"rgb(212,209,12)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"212.35" y=3D"687.5" >s..</text>=0A</g>=0A<=
g >=0A<title>__do_softirq (219,805,393 samples, 0.04%)</title><rect x=3D"97=
0.9" y=3D"533" width=3D"0.5" height=3D"15.0" fill=3D"rgb(243,93,54)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"973.94" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<=
title>check_stack_object (318,433,882 samples, 0.06%)</title><rect x=3D"941=
.4" y=3D"597" width=3D"0.7" height=3D"15.0" fill=3D"rgb(227,220,32)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"944.37" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<=
title>update_rq_clock (3,077,473,798 samples, 0.59%)</title><rect x=3D"1134=
.9" y=3D"565" width=3D"7.0" height=3D"15.0" fill=3D"rgb(250,170,31)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1137.91" y=3D"575.5" ></text>=0A</g>=0A<g >=0A=
<title>avc_has_perm (1,268,385,694 samples, 0.24%)</title><rect x=3D"171.7"=
 y=3D"565" width=3D"2.8" height=3D"15.0" fill=3D"rgb(244,146,15)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"174.67" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<tit=
le>change_protection (650,309,023 samples, 0.12%)</title><rect x=3D"1167.1"=
 y=3D"565" width=3D"1.4" height=3D"15.0" fill=3D"rgb(219,106,2)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1170.07" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<tit=
le>__GI___ioctl (61,959,949,789 samples, 11.89%)</title><rect x=3D"10.5" y=
=3D"677" width=3D"140.3" height=3D"15.0" fill=3D"rgb(225,122,42)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"13.49" y=3D"687.5" >__GI___ioctl</text>=0A</g>=0A=
<g >=0A<title>debug_smp_processor_id (144,472,106 samples, 0.03%)</title><r=
ect x=3D"697.5" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"rgb(222,113=
,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"700.52" y=3D"495.5" ></text>=0A</g=
>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (202,262,693 samples, 0.04%=
)</title><rect x=3D"332.5" y=3D"373" width=3D"0.5" height=3D"15.0" fill=3D"=
rgb(222,152,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"383.5" ></=
text>=0A</g>=0A<g >=0A<title>in_lock_functions (440,142,791 samples, 0.08%)=
</title><rect x=3D"871.3" y=3D"549" width=3D"1.0" height=3D"15.0" fill=3D"r=
gb(222,188,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"874.31" y=3D"559.5" ></t=
ext>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (151,196,233 sa=
mples, 0.03%)</title><rect x=3D"919.5" y=3D"677" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(233,85,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"=
687.5" ></text>=0A</g>=0A<g >=0A<title>migrate_task_rq_fair (1,492,953,641 =
samples, 0.29%)</title><rect x=3D"427.5" y=3D"277" width=3D"3.4" height=3D"=
15.0" fill=3D"rgb(234,105,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"430.53" y=
=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (737,509,=
951 samples, 0.14%)</title><rect x=3D"1151.3" y=3D"581" width=3D"1.7" heigh=
t=3D"15.0" fill=3D"rgb(246,147,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1154=
.28" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>rcu_note_context_switch (1=
11,836,943 samples, 0.02%)</title><rect x=3D"652.8" y=3D"325" width=3D"0.3"=
 height=3D"15.0" fill=3D"rgb(243,213,45)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"655.81" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>record_times (210,1=
41,805 samples, 0.04%)</title><rect x=3D"1098.7" y=3D"485" width=3D"0.5" he=
ight=3D"15.0" fill=3D"rgb(208,93,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
01.74" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>hva_to_pfn (177,969,923,=
625 samples, 34.16%)</title><rect x=3D"289.0" y=3D"517" width=3D"403.0" hei=
ght=3D"15.0" fill=3D"rgb(224,100,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"291=
.96" y=3D"527.5" >hva_to_pfn</text>=0A</g>=0A<g >=0A<title>__count_memcg_ev=
ents (426,920,764 samples, 0.08%)</title><rect x=3D"698.0" y=3D"469" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(249,9,27)" rx=3D"2" ry=3D"2" />=0A<tex=
t  x=3D"700.98" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick =
(674,230,216 samples, 0.13%)</title><rect x=3D"478.5" y=3D"181" width=3D"1.=
5" height=3D"15.0" fill=3D"rgb(226,133,34)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"481.47" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>fput (251,751,172 s=
amples, 0.05%)</title><rect x=3D"165.4" y=3D"613" width=3D"0.6" height=3D"1=
5.0" fill=3D"rgb(250,161,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"168.44" y=
=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>filemap_remove_folio (176,949,05=
9 samples, 0.03%)</title><rect x=3D"1180.0" y=3D"469" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(234,224,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.=
01" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>pick_next_task_fair (4,661,=
300,827 samples, 0.89%)</title><rect x=3D"628.1" y=3D"325" width=3D"10.5" h=
eight=3D"15.0" fill=3D"rgb(208,152,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
631.08" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>handle_userfault (120,7=
98,488,080 samples, 23.18%)</title><rect x=3D"388.8" y=3D"373" width=3D"273=
.6" height=3D"15.0" fill=3D"rgb(227,31,10)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"391.79" y=3D"383.5" >handle_userfault</text>=0A</g>=0A<g >=0A<title>__m=
mu_notifier_invalidate_range_start (46,889,230 samples, 0.01%)</title><rect=
 x=3D"141.5" y=3D"533" width=3D"0.1" height=3D"15.0" fill=3D"rgb(246,51,17)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.49" y=3D"543.5" ></text>=0A</g>=0A=
<g >=0A<title>x86_pmu_disable (62,483,032 samples, 0.01%)</title><rect x=3D=
"448.7" y=3D"309" width=3D"0.1" height=3D"15.0" fill=3D"rgb(223,77,15)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"451.68" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>sysvec_call_function_single (192,432,359 samples, 0.04%)</title><=
rect x=3D"388.3" y=3D"357" width=3D"0.5" height=3D"15.0" fill=3D"rgb(253,17=
6,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"391.33" y=3D"367.5" ></text>=0A</=
g>=0A<g >=0A<title>bpf_fd_pass (241,354,823 samples, 0.05%)</title><rect x=
=3D"174.5" y=3D"565" width=3D"0.6" height=3D"15.0" fill=3D"rgb(207,217,35)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"177.54" y=3D"575.5" ></text>=0A</g>=0A<=
g >=0A<title>scheduler_tick (151,196,233 samples, 0.03%)</title><rect x=3D"=
919.5" y=3D"549" width=3D"0.3" height=3D"15.0" fill=3D"rgb(215,193,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"559.5" ></text>=0A</g>=0A<g >=
=0A<title>select_task_rq_fair (6,186,489,328 samples, 1.19%)</title><rect x=
=3D"413.2" y=3D"293" width=3D"14.0" height=3D"15.0" fill=3D"rgb(230,40,23)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"416.20" y=3D"303.5" ></text>=0A</g>=0A<=
g >=0A<title>smp_call_function_single (55,888,500,077 samples, 10.73%)</tit=
le><rect x=3D"495.0" y=3D"261" width=3D"126.6" height=3D"15.0" fill=3D"rgb(=
225,202,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"498.00" y=3D"271.5" >smp_ca=
ll_functi..</text>=0A</g>=0A<g >=0A<title>tdp_mmu_zap_leafs (133,589,906 sa=
mples, 0.03%)</title><rect x=3D"806.0" y=3D"453" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(253,13,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D=
"463.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (192,863,=
815 samples, 0.04%)</title><rect x=3D"440.1" y=3D"261" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(246,161,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.0=
7" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (2=
12,050,157 samples, 0.04%)</title><rect x=3D"794.7" y=3D"517" width=3D"0.5"=
 height=3D"15.0" fill=3D"rgb(208,106,36)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"797.75" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__loaded_vmcs_clear=
 (142,021,616 samples, 0.03%)</title><rect x=3D"288.6" y=3D"437" width=3D"0=
.4" height=3D"15.0" fill=3D"rgb(208,142,27)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"291.64" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>__task_pid_nr_ns (=
2,507,516,449 samples, 0.48%)</title><rect x=3D"215.1" y=3D"613" width=3D"5=
.7" height=3D"15.0" fill=3D"rgb(213,180,21)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"218.11" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>schedule_hrtimeout=
_range_clock (71,214,058,165 samples, 13.67%)</title><rect x=3D"981.9" y=3D=
"613" width=3D"161.3" height=3D"15.0" fill=3D"rgb(211,130,0)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"984.89" y=3D"623.5" >schedule_hrtimeout_r..</text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_lock (733,701,263 samples, 0.14%)</titl=
e><rect x=3D"191.0" y=3D"581" width=3D"1.6" height=3D"15.0" fill=3D"rgb(209=
,53,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"193.98" y=3D"591.5" ></text>=0A=
</g>=0A<g >=0A<title>arch_tlbbatch_flush (181,644,572 samples, 0.03%)</titl=
e><rect x=3D"662.8" y=3D"373" width=3D"0.4" height=3D"15.0" fill=3D"rgb(228=
,85,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"665.79" y=3D"383.5" ></text>=0A<=
/g>=0A<g >=0A<title>dequeue_entity (14,132,644,213 samples, 2.71%)</title><=
rect x=3D"1003.5" y=3D"549" width=3D"32.0" height=3D"15.0" fill=3D"rgb(221,=
128,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1006.50" y=3D"559.5" >de..</tex=
t>=0A</g>=0A<g >=0A<title>kvm_mmu_hugepage_adjust (324,252,648 samples, 0.0=
6%)</title><rect x=3D"722.2" y=3D"517" width=3D"0.7" height=3D"15.0" fill=
=3D"rgb(254,127,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"725.17" y=3D"527.5"=
 ></text>=0A</g>=0A<g >=0A<title>__pthread_enable_asynccancel (781,306,812 =
samples, 0.15%)</title><rect x=3D"202.7" y=3D"677" width=3D"1.8" height=3D"=
15.0" fill=3D"rgb(248,71,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"205.70" y=
=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>__smp_call_single_queue (640,101=
,805 samples, 0.12%)</title><rect x=3D"618.6" y=3D"229" width=3D"1.5" heigh=
t=3D"15.0" fill=3D"rgb(234,54,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"621.6=
3" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>mark_page_accessed (140,239,=
628 samples, 0.03%)</title><rect x=3D"714.9" y=3D"517" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(214,158,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"717.8=
9" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__handle_changed_spte (905,1=
07,223 samples, 0.17%)</title><rect x=3D"720.1" y=3D"517" width=3D"2.0" hei=
ght=3D"15.0" fill=3D"rgb(230,124,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"72=
3.06" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>get_user_pages_fast_only =
(8,970,830,570 samples, 1.72%)</title><rect x=3D"292.1" y=3D"501" width=3D"=
20.3" height=3D"15.0" fill=3D"rgb(242,124,29)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"295.10" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption=
_disabled (423,476,222 samples, 0.08%)</title><rect x=3D"995.8" y=3D"533" w=
idth=3D"0.9" height=3D"15.0" fill=3D"rgb(230,5,19)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"998.78" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>demand_pagi=
ng_t (521,036,641,042 samples, 100.00%)</title><rect x=3D"10.0" y=3D"709" w=
idth=3D"1180.0" height=3D"15.0" fill=3D"rgb(233,4,1)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"13.00" y=3D"719.5" >demand_paging_t</text>=0A</g>=0A<g >=0A<=
title>dequeue_task_fair (7,219,859,032 samples, 1.39%)</title><rect x=3D"44=
9.9" y=3D"325" width=3D"16.4" height=3D"15.0" fill=3D"rgb(225,57,3)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"452.91" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<=
title>vmx_vcpu_load (61,775,678,050 samples, 11.86%)</title><rect x=3D"484.=
1" y=3D"293" width=3D"139.9" height=3D"15.0" fill=3D"rgb(221,99,25)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"487.07" y=3D"303.5" >vmx_vcpu_load</text>=0A</=
g>=0A<g >=0A<title>follow_page_mask (8,143,970,052 samples, 1.56%)</title><=
rect x=3D"333.0" y=3D"469" width=3D"18.4" height=3D"15.0" fill=3D"rgb(245,2=
5,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.99" y=3D"479.5" ></text>=0A</=
g>=0A<g >=0A<title>sysvec_call_function_single (142,021,616 samples, 0.03%)=
</title><rect x=3D"288.6" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"r=
gb(207,111,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"291.64" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (2,033,566,214 samples, 0.39%)<=
/title><rect x=3D"872.3" y=3D"581" width=3D"4.6" height=3D"15.0" fill=3D"rg=
b(223,55,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"875.31" y=3D"591.5" ></tex=
t>=0A</g>=0A<g >=0A<title>vmx_sched_in (65,710,263 samples, 0.01%)</title><=
rect x=3D"627.9" y=3D"293" width=3D"0.2" height=3D"15.0" fill=3D"rgb(215,11=
2,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"630.92" y=3D"303.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_is_mmio_pfn (941,024,250 samples, 0.18%)</title><rect=
 x=3D"723.6" y=3D"501" width=3D"2.1" height=3D"15.0" fill=3D"rgb(221,33,8)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"726.62" y=3D"511.5" ></text>=0A</g>=0A<=
g >=0A<title>_raw_read_lock (199,912,819 samples, 0.04%)</title><rect x=3D"=
280.0" y=3D"533" width=3D"0.5" height=3D"15.0" fill=3D"rgb(248,19,28)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"283.04" y=3D"543.5" ></text>=0A</g>=0A<g >=
=0A<title>kvm_mmu_page_fault (68,647,577 samples, 0.01%)</title><rect x=3D"=
10.3" y=3D"533" width=3D"0.2" height=3D"15.0" fill=3D"rgb(249,104,3)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<=
title>on_each_cpu_cond_mask (181,644,572 samples, 0.03%)</title><rect x=3D"=
662.8" y=3D"357" width=3D"0.4" height=3D"15.0" fill=3D"rgb(225,140,54)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"665.79" y=3D"367.5" ></text>=0A</g>=0A<g >=
=0A<title>sysvec_apic_timer_interrupt (182,704,004 samples, 0.04%)</title><=
rect x=3D"185.1" y=3D"533" width=3D"0.4" height=3D"15.0" fill=3D"rgb(221,22=
4,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"188.10" y=3D"543.5" ></text>=0A</=
g>=0A<g >=0A<title>tlb_finish_mmu (300,782,942 samples, 0.06%)</title><rect=
 x=3D"1180.4" y=3D"549" width=3D"0.7" height=3D"15.0" fill=3D"rgb(246,177,2=
0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>vmx_interrupt_allowed (741,177,276 samples, 0.14%)</title>=
<rect x=3D"692.7" y=3D"501" width=3D"1.6" height=3D"15.0" fill=3D"rgb(238,2=
16,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"695.66" y=3D"511.5" ></text>=0A<=
/g>=0A<g >=0A<title>shmem_truncate_range (625,495,838 samples, 0.12%)</titl=
e><rect x=3D"1179.0" y=3D"517" width=3D"1.4" height=3D"15.0" fill=3D"rgb(23=
5,208,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.99" y=3D"527.5" ></text>=
=0A</g>=0A<g >=0A<title>__update_load_avg_cfs_rq (125,950,915 samples, 0.02=
%)</title><rect x=3D"466.0" y=3D"293" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(247,36,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"468.97" y=3D"303.5" ></=
text>=0A</g>=0A<g >=0A<title>intel_guest_get_msrs (232,719,057 samples, 0.0=
4%)</title><rect x=3D"803.0" y=3D"565" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(250,163,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"806.03" y=3D"575.5" =
></text>=0A</g>=0A<g >=0A<title>pipe_poll (4,675,214,919 samples, 0.90%)</t=
itle><rect x=3D"959.7" y=3D"613" width=3D"10.6" height=3D"15.0" fill=3D"rgb=
(206,182,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"962.74" y=3D"623.5" ></tex=
t>=0A</g>=0A<g >=0A<title>available_idle_cpu (625,663,591 samples, 0.12%)</=
title><rect x=3D"1103.0" y=3D"517" width=3D"1.4" height=3D"15.0" fill=3D"rg=
b(238,148,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1105.98" y=3D"527.5" ></t=
ext>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irq (248,236,261 samples, 0.05%)=
</title><rect x=3D"187.0" y=3D"581" width=3D"0.6" height=3D"15.0" fill=3D"r=
gb(233,43,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"190.01" y=3D"591.5" ></te=
xt>=0A</g>=0A<g >=0A<title>check_preemption_disabled (120,506,012 samples, =
0.02%)</title><rect x=3D"98.5" y=3D"501" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(242,96,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.52" y=3D"511.5" =
></text>=0A</g>=0A<g >=0A<title>put_prev_task_fair (909,848,401 samples, 0.=
17%)</title><rect x=3D"1128.4" y=3D"565" width=3D"2.1" height=3D"15.0" fill=
=3D"rgb(205,117,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1131.40" y=3D"575.5"=
 ></text>=0A</g>=0A<g >=0A<title>in_lock_functions (243,658,128 samples, 0.=
05%)</title><rect x=3D"187.0" y=3D"549" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(246,7,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"190.02" y=3D"559.5" >=
</text>=0A</g>=0A<g >=0A<title>__vdso_clock_gettime (563,395,851 samples, 0=
.11%)</title><rect x=3D"206.5" y=3D"661" width=3D"1.3" height=3D"15.0" fill=
=3D"rgb(220,120,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"209.51" y=3D"671.5"=
 ></text>=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (18,167,045,218 samples, 3.=
49%)</title><rect x=3D"751.9" y=3D"549" width=3D"41.2" height=3D"15.0" fill=
=3D"rgb(254,2,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"754.95" y=3D"559.5" >=
[kv..</text>=0A</g>=0A<g >=0A<title>clockevents_program_event (200,976,249 =
samples, 0.04%)</title><rect x=3D"1153.0" y=3D"565" width=3D"0.4" height=3D=
"15.0" fill=3D"rgb(252,97,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1155.95" =
y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_mmu_zap_leafs (46,889,2=
30 samples, 0.01%)</title><rect x=3D"141.5" y=3D"485" width=3D"0.1" height=
=3D"15.0" fill=3D"rgb(229,172,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.4=
9" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (441,921,4=
48 samples, 0.08%)</title><rect x=3D"1032.3" y=3D"501" width=3D"1.0" height=
=3D"15.0" fill=3D"rgb(240,98,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1035.3=
4" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__tlb_remove_page_size (44,4=
19,622 samples, 0.01%)</title><rect x=3D"1181.7" y=3D"517" width=3D"0.1" he=
ight=3D"15.0" fill=3D"rgb(249,136,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1=
184.74" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_functio=
n_single (213,738,103 samples, 0.04%)</title><rect x=3D"919.8" y=3D"677" wi=
dth=3D"0.5" height=3D"15.0" fill=3D"rgb(206,210,43)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"922.83" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>irq_ente=
r_rcu (176,969,869 samples, 0.03%)</title><rect x=3D"388.3" y=3D"341" width=
=3D"0.4" height=3D"15.0" fill=3D"rgb(235,161,36)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"391.33" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_gr=
oup (1,461,471,228 samples, 0.28%)</title><rect x=3D"1008.5" y=3D"533" widt=
h=3D"3.3" height=3D"15.0" fill=3D"rgb(226,201,2)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1011.49" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__fib_valida=
te_source (147,822,297 samples, 0.03%)</title><rect x=3D"477.3" y=3D"53" wi=
dth=3D"0.3" height=3D"15.0" fill=3D"rgb(229,153,50)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"480.30" y=3D"63.5" ></text>=0A</g>=0A<g >=0A<title>perf_pmu_=
nop_void (505,822,487 samples, 0.10%)</title><rect x=3D"996.7" y=3D"549" wi=
dth=3D"1.2" height=3D"15.0" fill=3D"rgb(222,168,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"999.74" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>native_w=
rite_msr (430,185,517 samples, 0.08%)</title><rect x=3D"97.6" y=3D"485" wid=
th=3D"0.9" height=3D"15.0" fill=3D"rgb(229,112,41)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"100.55" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>raw_spin_rq=
_lock_nested (219,805,393 samples, 0.04%)</title><rect x=3D"970.9" y=3D"469=
" width=3D"0.5" height=3D"15.0" fill=3D"rgb(219,0,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"973.94" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>__x2apic=
_send_IPI_dest (254,447,320 samples, 0.05%)</title><rect x=3D"620.1" y=3D"2=
29" width=3D"0.6" height=3D"15.0" fill=3D"rgb(215,171,17)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"623.08" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>__rc=
u_read_unlock (497,396,442 samples, 0.10%)</title><rect x=3D"956.5" y=3D"59=
7" width=3D"1.1" height=3D"15.0" fill=3D"rgb(208,50,45)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"959.47" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>rebala=
nce_domains (103,156,189 samples, 0.02%)</title><rect x=3D"617.8" y=3D"181"=
 width=3D"0.2" height=3D"15.0" fill=3D"rgb(219,140,17)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"620.81" y=3D"191.5" ></text>=0A</g>=0A<g >=0A<title>folio_m=
ark_accessed (635,566,240 samples, 0.12%)</title><rect x=3D"358.0" y=3D"453=
" width=3D"1.4" height=3D"15.0" fill=3D"rgb(226,205,12)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"360.97" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>entry_=
SYSCALL_64 (111,259,166,987 samples, 21.35%)</title><rect x=3D"920.3" y=3D"=
677" width=3D"252.0" height=3D"15.0" fill=3D"rgb(205,53,16)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"923.31" y=3D"687.5" >entry_SYSCALL_64</text>=0A</g>=0A=
<g >=0A<title>load_balance (1,891,637,464 samples, 0.36%)</title><rect x=3D=
"632.2" y=3D"293" width=3D"4.3" height=3D"15.0" fill=3D"rgb(242,78,2)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"635.23" y=3D"303.5" ></text>=0A</g>=0A<g >=
=0A<title>net_rx_action (147,822,297 samples, 0.03%)</title><rect x=3D"477.=
3" y=3D"245" width=3D"0.3" height=3D"15.0" fill=3D"rgb(228,182,22)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__this_cpu_preempt_check (336,478,857 samples, 0.06%)</title><rect x=
=3D"1182.3" y=3D"421" width=3D"0.8" height=3D"15.0" fill=3D"rgb(249,108,12)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.30" y=3D"431.5" ></text>=0A</g>=
=0A<g >=0A<title>__audit_syscall_exit (1,491,071,741 samples, 0.29%)</title=
><rect x=3D"1168.6" y=3D"613" width=3D"3.3" height=3D"15.0" fill=3D"rgb(213=
,6,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.57" y=3D"623.5" ></text>=0A=
</g>=0A<g >=0A<title>_raw_spin_unlock_irqrestore (549,719,531 samples, 0.11=
%)</title><rect x=3D"438.8" y=3D"341" width=3D"1.2" height=3D"15.0" fill=3D=
"rgb(234,4,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"441.80" y=3D"351.5" ></t=
ext>=0A</g>=0A<g >=0A<title>check_cfs_rq_runtime (151,706,023 samples, 0.03=
%)</title><rect x=3D"652.0" y=3D"293" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(254,227,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"654.96" y=3D"303.5" ><=
/text>=0A</g>=0A<g >=0A<title>update_process_times (151,196,233 samples, 0.=
03%)</title><rect x=3D"919.5" y=3D"565" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(238,192,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D"575.5"=
 ></text>=0A</g>=0A<g >=0A<title>update_irq_load_avg (269,658,751 samples, =
0.05%)</title><rect x=3D"1076.3" y=3D"389" width=3D"0.6" height=3D"15.0" fi=
ll=3D"rgb(235,107,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1079.25" y=3D"399.=
5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (192,863,815 samples, 0=
.04%)</title><rect x=3D"440.1" y=3D"277" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(218,178,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.07" y=3D"287.5"=
 ></text>=0A</g>=0A<g >=0A<title>update_rq_clock (269,658,751 samples, 0.05=
%)</title><rect x=3D"1076.3" y=3D"405" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(220,136,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1079.25" y=3D"415.5=
" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (625,495,838 sa=
mples, 0.12%)</title><rect x=3D"1179.0" y=3D"629" width=3D"1.4" height=3D"1=
5.0" fill=3D"rgb(247,222,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.99" y=
=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>tdp_mmu_zap_leafs (46,889,230 sa=
mples, 0.01%)</title><rect x=3D"141.5" y=3D"469" width=3D"0.1" height=3D"15=
.0" fill=3D"rgb(234,187,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.49" y=
=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>free_unref_page_list (379,708,02=
7 samples, 0.07%)</title><rect x=3D"1179.1" y=3D"453" width=3D"0.9" height=
=3D"15.0" fill=3D"rgb(246,110,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1182.=
09" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>kvm_can_do_async_pf (1,028,=
826,744 samples, 0.20%)</title><rect x=3D"692.0" y=3D"517" width=3D"2.3" he=
ight=3D"15.0" fill=3D"rgb(252,86,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"69=
5.01" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__do_softirq (147,822,297=
 samples, 0.03%)</title><rect x=3D"477.3" y=3D"261" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(205,229,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=
=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>up_read (2,300,827,415 samples, =
0.44%)</title><rect x=3D"679.7" y=3D"485" width=3D"5.2" height=3D"15.0" fil=
l=3D"rgb(221,202,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"682.71" y=3D"495.5=
" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (875,695,984 samples=
, 0.17%)</title><rect x=3D"615.8" y=3D"181" width=3D"2.0" height=3D"15.0" f=
ill=3D"rgb(214,45,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.83" y=3D"191.=
5" ></text>=0A</g>=0A<g >=0A<title>do_vfs_ioctl (178,923,424 samples, 0.03%=
)</title><rect x=3D"253.7" y=3D"629" width=3D"0.4" height=3D"15.0" fill=3D"=
rgb(245,222,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"256.68" y=3D"639.5" ></=
text>=0A</g>=0A<g >=0A<title>tick_sched_timer (2,941,224,278 samples, 0.56%=
)</title><rect x=3D"1070.2" y=3D"469" width=3D"6.7" height=3D"15.0" fill=3D=
"rgb(253,179,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.22" y=3D"479.5" >=
</text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (151,196,233 s=
amples, 0.03%)</title><rect x=3D"919.5" y=3D"645" width=3D"0.3" height=3D"1=
5.0" fill=3D"rgb(219,145,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=
=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>ttwu_queue_wakelist (4,007,129,3=
58 samples, 0.77%)</title><rect x=3D"92.7" y=3D"517" width=3D"9.0" height=
=3D"15.0" fill=3D"rgb(222,105,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"95.66=
" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_call_function_single=
 (45,175,111 samples, 0.01%)</title><rect x=3D"440.5" y=3D"325" width=3D"0.=
1" height=3D"15.0" fill=3D"rgb(254,127,25)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"443.51" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>cgroup_rstat_update=
d (70,401,056 samples, 0.01%)</title><rect x=3D"457.0" y=3D"261" width=3D"0=
.2" height=3D"15.0" fill=3D"rgb(216,82,39)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"460.02" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_use=
r_mode (8,175,403,441 samples, 1.57%)</title><rect x=3D"1153.4" y=3D"645" w=
idth=3D"18.5" height=3D"15.0" fill=3D"rgb(236,173,46)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1156.43" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_unlock (472,244,763 samples, 0.09%)</title><rect x=3D"1032.3" y=3D"517" =
width=3D"1.0" height=3D"15.0" fill=3D"rgb(213,193,3)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1035.27" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>copy_pa=
ge (149,022,958 samples, 0.03%)</title><rect x=3D"662.4" y=3D"341" width=3D=
"0.3" height=3D"15.0" fill=3D"rgb(209,190,31)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"665.41" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title>generic_exec_sin=
gle (1,306,426,746 samples, 0.25%)</title><rect x=3D"618.6" y=3D"245" width=
=3D"3.0" height=3D"15.0" fill=3D"rgb(240,218,1)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"621.60" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (71,=
787,081 samples, 0.01%)</title><rect x=3D"10.0" y=3D"581" width=3D"0.2" hei=
ght=3D"15.0" fill=3D"rgb(230,83,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.=
00" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>mt_find (4,299,929,328 samp=
les, 0.83%)</title><rect x=3D"857.4" y=3D"581" width=3D"9.7" height=3D"15.0=
" fill=3D"rgb(205,114,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"860.36" y=3D"=
591.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (202,262,693 sample=
s, 0.04%)</title><rect x=3D"332.5" y=3D"325" width=3D"0.5" height=3D"15.0" =
fill=3D"rgb(243,192,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"33=
5.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (889,399,955 samples,=
 0.17%)</title><rect x=3D"704.2" y=3D"437" width=3D"2.0" height=3D"15.0" fi=
ll=3D"rgb(229,176,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"707.18" y=3D"447.5=
" ></text>=0A</g>=0A<g >=0A<title>dequeue_task (167,917,282 samples, 0.03%)=
</title><rect x=3D"449.5" y=3D"325" width=3D"0.4" height=3D"15.0" fill=3D"r=
gb(216,128,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"452.53" y=3D"335.5" ></t=
ext>=0A</g>=0A<g >=0A<title>tlb_flush_mmu (68,606,677 samples, 0.01%)</titl=
e><rect x=3D"1182.0" y=3D"517" width=3D"0.2" height=3D"15.0" fill=3D"rgb(22=
5,27,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.04" y=3D"527.5" ></text>=
=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (192,863,815 samples,=
 0.04%)</title><rect x=3D"440.1" y=3D"325" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(238,78,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.07" y=3D"335.5=
" ></text>=0A</g>=0A<g >=0A<title>__this_cpu_preempt_check (303,064,593 sam=
ples, 0.06%)</title><rect x=3D"59.8" y=3D"501" width=3D"0.7" height=3D"15.0=
" fill=3D"rgb(246,153,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.83" y=3D"51=
1.5" ></text>=0A</g>=0A<g >=0A<title>kvm_tdp_page_fault (203,264,651,642 sa=
mples, 39.01%)</title><rect x=3D"279.5" y=3D"549" width=3D"460.4" height=3D=
"15.0" fill=3D"rgb(250,141,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"282.55" =
y=3D"559.5" >kvm_tdp_page_fault</text>=0A</g>=0A<g >=0A<title>kvm_arch_sche=
d_in (304,244,541 samples, 0.06%)</title><rect x=3D"627.2" y=3D"293" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(252,40,16)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"630.23" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>napi_complete_=
done (147,822,297 samples, 0.03%)</title><rect x=3D"477.3" y=3D"197" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(231,99,19)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"480.30" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>__handle_mm_fa=
ult (131,918,558,450 samples, 25.32%)</title><rect x=3D"366.0" y=3D"453" wi=
dth=3D"298.8" height=3D"15.0" fill=3D"rgb(212,157,40)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"369.05" y=3D"463.5" >__handle_mm_fault</text>=0A</g>=0A<g >=
=0A<title>__fget_light (6,828,560,960 samples, 1.31%)</title><rect x=3D"942=
.1" y=3D"613" width=3D"15.5" height=3D"15.0" fill=3D"rgb(251,26,13)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"945.13" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<=
title>entry_SYSCALL_64 (19,499,342,266 samples, 3.74%)</title><rect x=3D"15=
2.0" y=3D"661" width=3D"44.2" height=3D"15.0" fill=3D"rgb(245,194,9)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"155.03" y=3D"671.5" >entr..</text>=0A</g>=0A<=
g >=0A<title>folio_unlock (1,367,055,589 samples, 0.26%)</title><rect x=3D"=
109.0" y=3D"581" width=3D"3.1" height=3D"15.0" fill=3D"rgb(253,86,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"111.98" y=3D"591.5" ></text>=0A</g>=0A<g >=
=0A<title>truncate_inode_folio (176,949,059 samples, 0.03%)</title><rect x=
=3D"1180.0" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"rgb(226,18,40)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.01" y=3D"495.5" ></text>=0A</g>=0A=
<g >=0A<title>update_load_avg (125,950,915 samples, 0.02%)</title><rect x=
=3D"466.0" y=3D"309" width=3D"0.3" height=3D"15.0" fill=3D"rgb(238,51,43)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"468.97" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>get_user_pages_unlocked (164,482,905,106 samples, 31.57%)</titl=
e><rect x=3D"312.4" y=3D"501" width=3D"372.5" height=3D"15.0" fill=3D"rgb(2=
11,137,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"315.41" y=3D"511.5" >get_use=
r_pages_unlocked</text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (291,014,089=
,562 samples, 55.85%)</title><rect x=3D"247.8" y=3D"645" width=3D"659.1" he=
ight=3D"15.0" fill=3D"rgb(232,119,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"2=
50.84" y=3D"655.5" >__x64_sys_ioctl</text>=0A</g>=0A<g >=0A<title>preempt_c=
ount_sub (760,160,990 samples, 0.15%)</title><rect x=3D"971.5" y=3D"581" wi=
dth=3D"1.7" height=3D"15.0" fill=3D"rgb(246,55,3)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"974.45" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_=
unlock (437,244,312 samples, 0.08%)</title><rect x=3D"353.5" y=3D"437" widt=
h=3D"1.0" height=3D"15.0" fill=3D"rgb(223,226,11)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"356.52" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>put_prev_ent=
ity (384,029,534 samples, 0.07%)</title><rect x=3D"651.4" y=3D"309" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(218,80,53)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"654.43" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__get_current_=
cr3_fast (1,912,991,828 samples, 0.37%)</title><rect x=3D"795.2" y=3D"565" =
width=3D"4.4" height=3D"15.0" fill=3D"rgb(246,96,12)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"798.23" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>apic_has=
_pending_timer (174,846,603 samples, 0.03%)</title><rect x=3D"254.7" y=3D"5=
97" width=3D"0.4" height=3D"15.0" fill=3D"rgb(254,173,32)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"257.69" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>_raw=
_spin_lock (735,942,662 samples, 0.14%)</title><rect x=3D"1130.5" y=3D"549"=
 width=3D"1.6" height=3D"15.0" fill=3D"rgb(223,72,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1133.46" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>record_=
times (611,945,742 samples, 0.12%)</title><rect x=3D"1138.9" y=3D"533" widt=
h=3D"1.4" height=3D"15.0" fill=3D"rgb(227,184,0)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1141.87" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>free_pcppage=
s_bulk (66,290,122 samples, 0.01%)</title><rect x=3D"1179.7" y=3D"437" widt=
h=3D"0.2" height=3D"15.0" fill=3D"rgb(235,36,54)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1182.70" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>preempt_coun=
t_sub (249,994,724 samples, 0.05%)</title><rect x=3D"1019.6" y=3D"501" widt=
h=3D"0.5" height=3D"15.0" fill=3D"rgb(238,187,1)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1022.56" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_u=
nlock (940,317,371 samples, 0.18%)</title><rect x=3D"1088.0" y=3D"533" widt=
h=3D"2.1" height=3D"15.0" fill=3D"rgb(225,76,27)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1091.00" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__wake_up_co=
mmon (14,810,469,000 samples, 2.84%)</title><rect x=3D"403.9" y=3D"341" wid=
th=3D"33.5" height=3D"15.0" fill=3D"rgb(210,32,24)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"406.87" y=3D"351.5" >__..</text>=0A</g>=0A<g >=0A<title>userfau=
ltfd_read (5,715,176,206 samples, 1.10%)</title><rect x=3D"179.7" y=3D"597"=
 width=3D"12.9" height=3D"15.0" fill=3D"rgb(222,92,42)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"182.70" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>raw_spi=
n_rq_lock_nested.constprop.116 (223,465,742 samples, 0.04%)</title><rect x=
=3D"652.3" y=3D"325" width=3D"0.5" height=3D"15.0" fill=3D"rgb(235,158,7)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"655.30" y=3D"335.5" ></text>=0A</g>=0A<g=
 >=0A<title>do_syscall_64 (1,259,337,616 samples, 0.24%)</title><rect x=3D"=
1180.4" y=3D"645" width=3D"2.9" height=3D"15.0" fill=3D"rgb(217,185,48)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"655.5" ></text>=0A</g>=0A<g =
>=0A<title>_raw_spin_unlock (636,239,470 samples, 0.12%)</title><rect x=3D"=
475.7" y=3D"293" width=3D"1.5" height=3D"15.0" fill=3D"rgb(242,81,1)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"478.73" y=3D"303.5" ></text>=0A</g>=0A<g >=0A=
<title>__gfn_to_pfn_memslot (1,069,893,587 samples, 0.21%)</title><rect x=
=3D"286.5" y=3D"517" width=3D"2.5" height=3D"15.0" fill=3D"rgb(226,31,34)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"289.54" y=3D"527.5" ></text>=0A</g>=0A<g=
 >=0A<title>update_process_times (202,262,693 samples, 0.04%)</title><rect =
x=3D"332.5" y=3D"293" width=3D"0.5" height=3D"15.0" fill=3D"rgb(251,140,30)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"303.5" ></text>=0A</g>=0A=
<g >=0A<title>__audit_syscall_entry (379,430,385 samples, 0.07%)</title><re=
ct x=3D"195.3" y=3D"613" width=3D"0.8" height=3D"15.0" fill=3D"rgb(235,61,3=
8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"198.26" y=3D"623.5" ></text>=0A</g>=
=0A<g >=0A<title>__gfn_to_hva_many (424,861,685 samples, 0.08%)</title><rec=
t x=3D"287.7" y=3D"501" width=3D"0.9" height=3D"15.0" fill=3D"rgb(252,32,32=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"290.68" y=3D"511.5" ></text>=0A</g>=
=0A<g >=0A<title>sched_clock_cpu (635,007,466 samples, 0.12%)</title><rect =
x=3D"649.3" y=3D"309" width=3D"1.4" height=3D"15.0" fill=3D"rgb(251,202,49)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"652.30" y=3D"319.5" ></text>=0A</g>=0A=
<g >=0A<title>shmem_evict_inode (625,495,838 samples, 0.12%)</title><rect x=
=3D"1179.0" y=3D"533" width=3D"1.4" height=3D"15.0" fill=3D"rgb(226,8,22)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.99" y=3D"543.5" ></text>=0A</g>=0A<=
g >=0A<title>[unknown] (61,126,733 samples, 0.01%)</title><rect x=3D"10.0" =
y=3D"565" width=3D"0.1" height=3D"15.0" fill=3D"rgb(218,30,33)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"13.00" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>=
preempt_count_add (357,504,262 samples, 0.07%)</title><rect x=3D"677.8" y=
=3D"469" width=3D"0.8" height=3D"15.0" fill=3D"rgb(250,109,27)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"680.83" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title=
>task_numa_work (650,309,023 samples, 0.12%)</title><rect x=3D"1167.1" y=3D=
"597" width=3D"1.4" height=3D"15.0" fill=3D"rgb(218,24,7)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1170.07" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>vmx=
_get_rflags (448,833,024 samples, 0.09%)</title><rect x=3D"693.3" y=3D"469"=
 width=3D"1.0" height=3D"15.0" fill=3D"rgb(245,12,1)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"696.32" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>rcu_note=
_context_switch (943,687,758 samples, 0.18%)</title><rect x=3D"793.1" y=3D"=
549" width=3D"2.1" height=3D"15.0" fill=3D"rgb(206,164,28)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"796.09" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>sch=
ed_clock_cpu (1,293,151,316 samples, 0.25%)</title><rect x=3D"1125.5" y=3D"=
549" width=3D"2.9" height=3D"15.0" fill=3D"rgb(215,147,46)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"1128.47" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>sc=
hed_clock_cpu (260,047,181 samples, 0.05%)</title><rect x=3D"637.7" y=3D"26=
1" width=3D"0.6" height=3D"15.0" fill=3D"rgb(231,38,16)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"640.73" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>flush_=
tlb_func (151,189,230 samples, 0.03%)</title><rect x=3D"265.9" y=3D"501" wi=
dth=3D"0.3" height=3D"15.0" fill=3D"rgb(253,223,6)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"268.87" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>shmem_fault=
 (125,947,399,129 samples, 24.17%)</title><rect x=3D"377.1" y=3D"405" width=
=3D"285.3" height=3D"15.0" fill=3D"rgb(240,227,24)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"380.13" y=3D"415.5" >shmem_fault</text>=0A</g>=0A<g >=0A<title>=
hrtimer_interrupt (218,927,022 samples, 0.04%)</title><rect x=3D"483.5" y=
=3D"245" width=3D"0.5" height=3D"15.0" fill=3D"rgb(246,203,25)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"486.47" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title=
>psi_task_switch (10,598,410,971 samples, 2.03%)</title><rect x=3D"1104.4" =
y=3D"565" width=3D"24.0" height=3D"15.0" fill=3D"rgb(236,79,5)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1107.39" y=3D"575.5" >p..</text>=0A</g>=0A<g >=0A<t=
itle>kvm_release_pfn_clean (564,796,966 samples, 0.11%)</title><rect x=3D"7=
15.2" y=3D"533" width=3D"1.3" height=3D"15.0" fill=3D"rgb(223,137,19)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"718.21" y=3D"543.5" ></text>=0A</g>=0A<g >=
=0A<title>__x64_sys_ioctl (82,977,526 samples, 0.02%)</title><rect x=3D"10.=
3" y=3D"613" width=3D"0.2" height=3D"15.0" fill=3D"rgb(226,18,41)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"13.30" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<tit=
le>native_write_msr (1,496,573,732 samples, 0.29%)</title><rect x=3D"1057.4=
" y=3D"517" width=3D"3.4" height=3D"15.0" fill=3D"rgb(217,160,20)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1060.37" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<t=
itle>flush_tlb_batched_pending (242,233,493 samples, 0.05%)</title><rect x=
=3D"1168.0" y=3D"549" width=3D"0.5" height=3D"15.0" fill=3D"rgb(212,174,2)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1171.00" y=3D"559.5" ></text>=0A</g>=0A=
<g >=0A<title>_raw_spin_unlock (189,168,427 samples, 0.04%)</title><rect x=
=3D"1070.7" y=3D"389" width=3D"0.4" height=3D"15.0" fill=3D"rgb(209,40,35)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.70" y=3D"399.5" ></text>=0A</g>=0A=
<g >=0A<title>do_raw_spin_lock (277,070,645 samples, 0.05%)</title><rect x=
=3D"1151.8" y=3D"565" width=3D"0.6" height=3D"15.0" fill=3D"rgb(247,7,27)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"1154.79" y=3D"575.5" ></text>=0A</g>=0A<=
g >=0A<title>xas_start (304,886,001 samples, 0.06%)</title><rect x=3D"906.2=
" y=3D"533" width=3D"0.7" height=3D"15.0" fill=3D"rgb(215,159,14)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"909.21" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__rcu_read_unlock (442,034,124 samples, 0.08%)</title><rect x=3D"252.7"=
 y=3D"613" width=3D"1.0" height=3D"15.0" fill=3D"rgb(215,169,40)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"255.68" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<tit=
le>migrate_pages_batch (366,968,562 samples, 0.07%)</title><rect x=3D"662.4=
" y=3D"405" width=3D"0.8" height=3D"15.0" fill=3D"rgb(232,148,54)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"665.37" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__sysvec_apic_timer_interrupt (58,323,375 samples, 0.01%)</title><rect =
x=3D"439.1" y=3D"293" width=3D"0.1" height=3D"15.0" fill=3D"rgb(248,128,25)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.11" y=3D"303.5" ></text>=0A</g>=0A=
<g >=0A<title>__sysvec_call_function_single (132,942,133 samples, 0.03%)</t=
itle><rect x=3D"353.2" y=3D"389" width=3D"0.3" height=3D"15.0" fill=3D"rgb(=
243,213,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"356.18" y=3D"399.5" ></text=
>=0A</g>=0A<g >=0A<title>irq_exit_rcu (54,463,702 samples, 0.01%)</title><r=
ect x=3D"482.3" y=3D"277" width=3D"0.1" height=3D"15.0" fill=3D"rgb(210,118=
,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"485.26" y=3D"287.5" ></text>=0A</g>=
=0A<g >=0A<title>psi_task_change (550,146,852 samples, 0.11%)</title><rect =
x=3D"91.4" y=3D"501" width=3D"1.3" height=3D"15.0" fill=3D"rgb(216,88,19)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"94.41" y=3D"511.5" ></text>=0A</g>=0A<g =
>=0A<title>update_load_avg (157,093,661 samples, 0.03%)</title><rect x=3D"1=
091.9" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"rgb(211,26,42)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1094.89" y=3D"495.5" ></text>=0A</g>=0A<g =
>=0A<title>PageHeadHuge (206,669,814 samples, 0.04%)</title><rect x=3D"898.=
8" y=3D"549" width=3D"0.5" height=3D"15.0" fill=3D"rgb(223,156,12)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"901.80" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<t=
itle>do_raw_spin_lock (614,520,545 samples, 0.12%)</title><rect x=3D"464.2"=
 y=3D"277" width=3D"1.4" height=3D"15.0" fill=3D"rgb(233,95,38)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"467.18" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<titl=
e>sysvec_apic_timer_interrupt (273,764,802 samples, 0.05%)</title><rect x=
=3D"107.7" y=3D"565" width=3D"0.7" height=3D"15.0" fill=3D"rgb(227,175,22)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"575.5" ></text>=0A</g>=0A<=
g >=0A<title>syscall_trace_enter.isra.17 (150,334,152 samples, 0.03%)</titl=
e><rect x=3D"1171.9" y=3D"645" width=3D"0.4" height=3D"15.0" fill=3D"rgb(24=
0,100,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1174.94" y=3D"655.5" ></text>=
=0A</g>=0A<g >=0A<title>ktime_get (200,976,249 samples, 0.04%)</title><rect=
 x=3D"1153.0" y=3D"549" width=3D"0.4" height=3D"15.0" fill=3D"rgb(233,132,2=
7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1155.95" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>is_page_fault_stale (166,947,077 samples, 0.03%)</title><r=
ect x=3D"284.8" y=3D"533" width=3D"0.4" height=3D"15.0" fill=3D"rgb(253,194=
,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"287.79" y=3D"543.5" ></text>=0A</g=
>=0A<g >=0A<title>vmx_set_host_fs_gs (79,224,593 samples, 0.02%)</title><re=
ct x=3D"747.6" y=3D"565" width=3D"0.2" height=3D"15.0" fill=3D"rgb(245,15,3=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"750.61" y=3D"575.5" ></text>=0A</g>=
=0A<g >=0A<title>queued_read_lock_slowpath (2,816,554,827 samples, 0.54%)</=
title><rect x=3D"733.5" y=3D"533" width=3D"6.4" height=3D"15.0" fill=3D"rgb=
(211,21,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"736.50" y=3D"543.5" ></text=
>=0A</g>=0A<g >=0A<title>pick_next_task_idle (1,879,586,038 samples, 0.36%)=
</title><rect x=3D"1100.1" y=3D"565" width=3D"4.3" height=3D"15.0" fill=3D"=
rgb(229,177,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1103.14" y=3D"575.5" ><=
/text>=0A</g>=0A<g >=0A<title>__do_fault (126,368,343,114 samples, 24.25%)<=
/title><rect x=3D"376.2" y=3D"421" width=3D"286.2" height=3D"15.0" fill=3D"=
rgb(227,148,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"379.18" y=3D"431.5" >__=
do_fault</text>=0A</g>=0A<g >=0A<title>__hrtimer_run_queues (151,196,233 sa=
mples, 0.03%)</title><rect x=3D"919.5" y=3D"613" width=3D"0.3" height=3D"15=
.0" fill=3D"rgb(220,29,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"922.49" y=3D=
"623.5" ></text>=0A</g>=0A<g >=0A<title>scheduler_tick (866,787,999 samples=
, 0.17%)</title><rect x=3D"615.8" y=3D"117" width=3D"2.0" height=3D"15.0" f=
ill=3D"rgb(240,213,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.85" y=3D"127=
.5" ></text>=0A</g>=0A<g >=0A<title>_find_next_and_bit (204,892,735 samples=
, 0.04%)</title><rect x=3D"60.5" y=3D"501" width=3D"0.5" height=3D"15.0" fi=
ll=3D"rgb(218,205,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"63.51" y=3D"511.5=
" ></text>=0A</g>=0A<g >=0A<title>__x86_indirect_thunk_array (53,934,550 sa=
mples, 0.01%)</title><rect x=3D"247.2" y=3D"677" width=3D"0.1" height=3D"15=
.0" fill=3D"rgb(206,20,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"250.20" y=3D=
"687.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (265,842,308 samp=
les, 0.05%)</title><rect x=3D"107.7" y=3D"533" width=3D"0.6" height=3D"15.0=
" fill=3D"rgb(236,4,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"54=
3.5" ></text>=0A</g>=0A<g >=0A<title>tdp_iter_start (338,490,349 samples, 0=
.06%)</title><rect x=3D"730.9" y=3D"517" width=3D"0.7" height=3D"15.0" fill=
=3D"rgb(247,66,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"733.86" y=3D"527.5" =
></text>=0A</g>=0A<g >=0A<title>pick_next_task_fair (7,504,013,845 samples,=
 1.44%)</title><rect x=3D"1083.1" y=3D"565" width=3D"17.0" height=3D"15.0" =
fill=3D"rgb(209,130,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1086.14" y=3D"57=
5.5" ></text>=0A</g>=0A<g >=0A<title>mt_find (3,685,635,351 samples, 0.71%)=
</title><rect x=3D"324.6" y=3D"437" width=3D"8.4" height=3D"15.0" fill=3D"r=
gb(245,111,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"327.64" y=3D"447.5" ></t=
ext>=0A</g>=0A<g >=0A<title>release_pages (300,782,942 samples, 0.06%)</tit=
le><rect x=3D"1180.4" y=3D"517" width=3D"0.7" height=3D"15.0" fill=3D"rgb(2=
11,88,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"527.5" ></text>=
=0A</g>=0A<g >=0A<title>selinux_file_permission (1,700,497,527 samples, 0.3=
3%)</title><rect x=3D"175.8" y=3D"581" width=3D"3.9" height=3D"15.0" fill=
=3D"rgb(236,200,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"178.85" y=3D"591.5"=
 ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_ioctl (243,866,017,812 samples, 4=
6.80%)</title><rect x=3D"254.1" y=3D"629" width=3D"552.3" height=3D"15.0" f=
ill=3D"rgb(227,61,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"257.08" y=3D"639.=
5" >kvm_vcpu_ioctl</text>=0A</g>=0A<g >=0A<title>migrate_folio_extra (149,0=
22,958 samples, 0.03%)</title><rect x=3D"662.4" y=3D"373" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(236,21,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"665=
.41" y=3D"383.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_inte=
rrupt (273,764,802 samples, 0.05%)</title><rect x=3D"107.7" y=3D"581" width=
=3D"0.7" height=3D"15.0" fill=3D"rgb(242,13,48)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"110.74" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_has_n=
oncoherent_dma (241,368,200 samples, 0.05%)</title><rect x=3D"727.3" y=3D"4=
85" width=3D"0.6" height=3D"15.0" fill=3D"rgb(252,187,38)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"730.31" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>dequ=
eue_task (826,468,950 samples, 0.16%)</title><rect x=3D"999.4" y=3D"565" wi=
dth=3D"1.8" height=3D"15.0" fill=3D"rgb(251,124,2)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"1002.36" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>_find_next=
_bit (1,044,633,434 samples, 0.20%)</title><rect x=3D"418.7" y=3D"277" widt=
h=3D"2.4" height=3D"15.0" fill=3D"rgb(222,152,24)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"421.71" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_call_=
function (151,189,230 samples, 0.03%)</title><rect x=3D"265.9" y=3D"549" wi=
dth=3D"0.3" height=3D"15.0" fill=3D"rgb(249,74,31)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"268.87" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>schedule (9=
4,772,496,213 samples, 18.19%)</title><rect x=3D"441.9" y=3D"357" width=3D"=
214.7" height=3D"15.0" fill=3D"rgb(252,70,22)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"444.92" y=3D"367.5" >schedule</text>=0A</g>=0A<g >=0A<title>remove_w=
ait_queue (3,793,711,890 samples, 0.73%)</title><rect x=3D"973.3" y=3D"597"=
 width=3D"8.6" height=3D"15.0" fill=3D"rgb(247,159,28)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"976.30" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>_raw_sp=
in_lock (661,014,012 samples, 0.13%)</title><rect x=3D"185.5" y=3D"581" wid=
th=3D"1.5" height=3D"15.0" fill=3D"rgb(244,176,26)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"188.51" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>check_preem=
ption_disabled (298,473,488 samples, 0.06%)</title><rect x=3D"72.0" y=3D"50=
1" width=3D"0.7" height=3D"15.0" fill=3D"rgb(219,61,20)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"74.98" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_=
call_function_single (64,445,321 samples, 0.01%)</title><rect x=3D"440.5" y=
=3D"341" width=3D"0.2" height=3D"15.0" fill=3D"rgb(209,31,20)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"443.51" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<title=
>sysvec_apic_timer_interrupt (200,976,249 samples, 0.04%)</title><rect x=3D=
"1153.0" y=3D"613" width=3D"0.4" height=3D"15.0" fill=3D"rgb(235,158,29)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"1155.95" y=3D"623.5" ></text>=0A</g>=0A<g=
 >=0A<title>native_read_msr (228,862,946 samples, 0.04%)</title><rect x=3D"=
484.4" y=3D"277" width=3D"0.5" height=3D"15.0" fill=3D"rgb(233,26,29)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"487.38" y=3D"287.5" ></text>=0A</g>=0A<g >=
=0A<title>send_call_function_single_ipi (351,089,994 samples, 0.07%)</title=
><rect x=3D"100.1" y=3D"501" width=3D"0.8" height=3D"15.0" fill=3D"rgb(235,=
14,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"103.11" y=3D"511.5" ></text>=0A<=
/g>=0A<g >=0A<title>rcu_preempt_need_deferred_qs (202,377,341 samples, 0.04=
%)</title><rect x=3D"1133.7" y=3D"533" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(226,50,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1136.74" y=3D"543.5"=
 ></text>=0A</g>=0A<g >=0A<title>preempt_count_sub (148,790,845 samples, 0.=
03%)</title><rect x=3D"478.5" y=3D"133" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(224,185,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"481.50" y=3D"143.5"=
 ></text>=0A</g>=0A<g >=0A<title>psi_account_irqtime (695,852,585 samples, =
0.13%)</title><rect x=3D"101.7" y=3D"501" width=3D"1.6" height=3D"15.0" fil=
l=3D"rgb(226,62,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"104.75" y=3D"511.5"=
 ></text>=0A</g>=0A<g >=0A<title>down_read_killable (5,714,360,816 samples,=
 1.10%)</title><rect x=3D"666.1" y=3D"485" width=3D"13.0" height=3D"15.0" f=
ill=3D"rgb(231,78,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"669.11" y=3D"495.5=
" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_load (62,489,395,541 sample=
s, 11.99%)</title><rect x=3D"482.5" y=3D"309" width=3D"141.5" height=3D"15.=
0" fill=3D"rgb(253,11,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"485.46" y=3D"=
319.5" >kvm_arch_vcpu_load</text>=0A</g>=0A<g >=0A<title>__srcu_read_lock (=
814,405,151 samples, 0.16%)</title><rect x=3D"260.5" y=3D"581" width=3D"1.8=
" height=3D"15.0" fill=3D"rgb(235,86,38)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"263.48" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>update_curr (4,490,=
678,961 samples, 0.86%)</title><rect x=3D"1011.8" y=3D"533" width=3D"10.2" =
height=3D"15.0" fill=3D"rgb(211,101,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1014.80" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (740=
,060,016 samples, 0.14%)</title><rect x=3D"1033.3" y=3D"517" width=3D"1.7" =
height=3D"15.0" fill=3D"rgb(220,10,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1036.34" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_apic_timer_=
interrupt (202,262,693 samples, 0.04%)</title><rect x=3D"332.5" y=3D"405" w=
idth=3D"0.5" height=3D"15.0" fill=3D"rgb(230,183,49)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"335.53" y=3D"415.5" ></text>=0A</g>=0A<g >=0A<title>selinux_=
file_ioctl (267,277,355 samples, 0.05%)</title><rect x=3D"814.7" y=3D"613" =
width=3D"0.6" height=3D"15.0" fill=3D"rgb(248,20,51)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"817.67" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>vmx_flus=
h_tlb_all (1,483,414,695 samples, 0.28%)</title><rect x=3D"271.2" y=3D"581"=
 width=3D"3.4" height=3D"15.0" fill=3D"rgb(213,22,54)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"274.22" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>entry_SY=
SCALL_64 (239,755,972 samples, 0.05%)</title><rect x=3D"201.4" y=3D"661" wi=
dth=3D"0.5" height=3D"15.0" fill=3D"rgb(244,151,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"204.41" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<title>userfaul=
tfd_wake_function (35,721,583,741 samples, 6.86%)</title><rect x=3D"22.5" y=
=3D"549" width=3D"80.9" height=3D"15.0" fill=3D"rgb(216,167,32)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"25.45" y=3D"559.5" >userfault..</text>=0A</g>=0A<g=
 >=0A<title>asm_sysvec_apic_timer_interrupt (218,927,022 samples, 0.04%)</t=
itle><rect x=3D"483.5" y=3D"293" width=3D"0.5" height=3D"15.0" fill=3D"rgb(=
246,130,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"486.47" y=3D"303.5" ></text=
>=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (405,262,782 samples, 0.08%)</t=
itle><rect x=3D"34.1" y=3D"501" width=3D"0.9" height=3D"15.0" fill=3D"rgb(2=
31,84,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"37.05" y=3D"511.5" ></text>=0A=
</g>=0A<g >=0A<title>cgroup_base_stat_cputime_account_end.isra.12 (194,012,=
109 samples, 0.04%)</title><rect x=3D"456.8" y=3D"277" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(229,43,26)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"459.76=
" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>native_write_msr (329,117,808=
 samples, 0.06%)</title><rect x=3D"804.1" y=3D"565" width=3D"0.8" height=3D=
"15.0" fill=3D"rgb(244,65,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"807.13" y=
=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>psi_account_irqtime (215,881,895=
 samples, 0.04%)</title><rect x=3D"637.2" y=3D"261" width=3D"0.5" height=3D=
"15.0" fill=3D"rgb(225,144,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"640.24" =
y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__cond_resched_rwlock_write (40=
8,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=3D"469" width=3D"0.9"=
 height=3D"15.0" fill=3D"rgb(253,43,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"1170.07" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (5,76=
2,690,092 samples, 1.11%)</title><rect x=3D"1022.0" y=3D"533" width=3D"13.0=
" height=3D"15.0" fill=3D"rgb(240,84,45)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1024.97" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add =
(522,882,164 samples, 0.10%)</title><rect x=3D"35.4" y=3D"517" width=3D"1.2=
" height=3D"15.0" fill=3D"rgb(231,184,47)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"38.38" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>rcu_preempt_deferred=
_qs (55,590,395 samples, 0.01%)</title><rect x=3D"794.6" y=3D"533" width=3D=
"0.1" height=3D"15.0" fill=3D"rgb(208,144,16)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"797.59" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>__loaded_vmcs_cl=
ear (479,606,325 samples, 0.09%)</title><rect x=3D"480.9" y=3D"245" width=
=3D"1.1" height=3D"15.0" fill=3D"rgb(235,69,19)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"483.89" y=3D"255.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlo=
ck_irq (534,255,001 samples, 0.10%)</title><rect x=3D"107.7" y=3D"597" widt=
h=3D"1.2" height=3D"15.0" fill=3D"rgb(248,226,18)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"110.72" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>attach_task =
(493,616,072 samples, 0.09%)</title><rect x=3D"1090.8" y=3D"517" width=3D"1=
.1" height=3D"15.0" fill=3D"rgb(211,220,30)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1093.77" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (=
162,867,555 samples, 0.03%)</title><rect x=3D"617.4" y=3D"85" width=3D"0.4"=
 height=3D"15.0" fill=3D"rgb(226,93,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
620.44" y=3D"95.5" ></text>=0A</g>=0A<g >=0A<title>try_grab_page (639,086,2=
24 samples, 0.12%)</title><rect x=3D"359.4" y=3D"453" width=3D"1.5" height=
=3D"15.0" fill=3D"rgb(206,173,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"362.4=
4" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_max_mapping_level (3=
09,340,618 samples, 0.06%)</title><rect x=3D"722.2" y=3D"501" width=3D"0.7"=
 height=3D"15.0" fill=3D"rgb(243,142,15)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"725.21" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>find_busiest_group =
(1,232,033,093 samples, 0.24%)</title><rect x=3D"633.3" y=3D"277" width=3D"=
2.8" height=3D"15.0" fill=3D"rgb(225,79,37)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"636.30" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>page_fault_handle_=
page_track.isra.117 (218,910,604 samples, 0.04%)</title><rect x=3D"733.0" y=
=3D"533" width=3D"0.5" height=3D"15.0" fill=3D"rgb(209,143,52)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"736.01" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title=
>shmem_get_folio (6,119,441,821 samples, 1.17%)</title><rect x=3D"893.0" y=
=3D"597" width=3D"13.9" height=3D"15.0" fill=3D"rgb(233,139,6)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"896.04" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title=
>irq_exit_rcu (182,704,004 samples, 0.04%)</title><rect x=3D"185.1" y=3D"51=
7" width=3D"0.4" height=3D"15.0" fill=3D"rgb(236,195,28)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"188.10" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>__per=
f_event_task_sched_out (1,750,004,692 samples, 0.34%)</title><rect x=3D"444=
.9" y=3D"325" width=3D"3.9" height=3D"15.0" fill=3D"rgb(214,20,14)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"447.86" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<t=
itle>raw_spin_rq_lock_nested (559,804,875 samples, 0.11%)</title><rect x=3D=
"1094.4" y=3D"517" width=3D"1.3" height=3D"15.0" fill=3D"rgb(212,11,30)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1097.41" y=3D"527.5" ></text>=0A</g>=0A<g =
>=0A<title>update_cfs_group (124,437,407 samples, 0.02%)</title><rect x=3D"=
453.1" y=3D"293" width=3D"0.3" height=3D"15.0" fill=3D"rgb(245,51,21)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"456.10" y=3D"303.5" ></text>=0A</g>=0A<g >=
=0A<title>debug_smp_processor_id (163,771,065 samples, 0.03%)</title><rect =
x=3D"270.1" y=3D"565" width=3D"0.4" height=3D"15.0" fill=3D"rgb(226,77,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"273.11" y=3D"575.5" ></text>=0A</g>=0A<=
g >=0A<title>update_process_times (2,926,905,563 samples, 0.56%)</title><re=
ct x=3D"1070.3" y=3D"437" width=3D"6.6" height=3D"15.0" fill=3D"rgb(219,66,=
42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.26" y=3D"447.5" ></text>=0A</g=
>=0A<g >=0A<title>do_raw_spin_lock (65,432,660 samples, 0.01%)</title><rect=
 x=3D"190.8" y=3D"549" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,34,35)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"193.82" y=3D"559.5" ></text>=0A</g>=0A=
<g >=0A<title>irq_exit_rcu (219,805,393 samples, 0.04%)</title><rect x=3D"9=
70.9" y=3D"549" width=3D"0.5" height=3D"15.0" fill=3D"rgb(245,49,38)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"973.94" y=3D"559.5" ></text>=0A</g>=0A<g >=0A=
<title>raw_spin_rq_lock_nested (187,249,711 samples, 0.04%)</title><rect x=
=3D"636.1" y=3D"277" width=3D"0.4" height=3D"15.0" fill=3D"rgb(246,76,42)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"639.09" y=3D"287.5" ></text>=0A</g>=0A<g=
 >=0A<title>remove_entity_load_avg (1,778,801,534 samples, 0.34%)</title><r=
ect x=3D"84.5" y=3D"485" width=3D"4.0" height=3D"15.0" fill=3D"rgb(250,95,5=
4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.51" y=3D"495.5" ></text>=0A</g>=
=0A<g >=0A<title>set_next_task_idle (661,384,240 samples, 0.13%)</title><re=
ct x=3D"638.6" y=3D"309" width=3D"1.5" height=3D"15.0" fill=3D"rgb(217,169,=
17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"641.63" y=3D"319.5" ></text>=0A</g>=
=0A<g >=0A<title>update_process_times (866,787,999 samples, 0.17%)</title><=
rect x=3D"615.8" y=3D"133" width=3D"2.0" height=3D"15.0" fill=3D"rgb(211,79=
,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.85" y=3D"143.5" ></text>=0A</g=
>=0A<g >=0A<title>xas_load (3,345,075,275 samples, 0.64%)</title><rect x=3D=
"899.3" y=3D"549" width=3D"7.6" height=3D"15.0" fill=3D"rgb(220,125,23)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"902.32" y=3D"559.5" ></text>=0A</g>=0A<g >=
=0A<title>up_read (7,949,629,949 samples, 1.53%)</title><rect x=3D"112.2" y=
=3D"581" width=3D"18.0" height=3D"15.0" fill=3D"rgb(241,62,29)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"115.16" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>preempt_count_sub (182,344,392 samples, 0.03%)</title><rect x=3D"678.6" y=
=3D"469" width=3D"0.5" height=3D"15.0" fill=3D"rgb(222,179,36)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"681.64" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title=
>_raw_spin_lock_irq (1,366,495,695 samples, 0.26%)</title><rect x=3D"104.2"=
 y=3D"581" width=3D"3.1" height=3D"15.0" fill=3D"rgb(212,172,31)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"107.17" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<tit=
le>tick_sched_handle.isra.21 (202,262,693 samples, 0.04%)</title><rect x=3D=
"332.5" y=3D"309" width=3D"0.5" height=3D"15.0" fill=3D"rgb(234,211,3)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"319.5" ></text>=0A</g>=0A<g >=
=0A<title>pmd_val (167,861,248 samples, 0.03%)</title><rect x=3D"664.0" y=
=3D"421" width=3D"0.4" height=3D"15.0" fill=3D"rgb(238,124,34)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"667.02" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title=
>intel_pmu_disable_all (692,774,700 samples, 0.13%)</title><rect x=3D"993.4=
" y=3D"549" width=3D"1.6" height=3D"15.0" fill=3D"rgb(249,27,29)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"996.39" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<tit=
le>preempt_count_sub (1,273,354,767 samples, 0.24%)</title><rect x=3D"1064.=
2" y=3D"517" width=3D"2.8" height=3D"15.0" fill=3D"rgb(237,1,47)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1067.15" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>sysvec_call_function_single (132,942,133 samples, 0.03%)</title><rect x=
=3D"353.2" y=3D"405" width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,36,16)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"356.18" y=3D"415.5" ></text>=0A</g>=0A<g=
 >=0A<title>do_raw_spin_lock (292,717,200 samples, 0.06%)</title><rect x=3D=
"103.4" y=3D"549" width=3D"0.6" height=3D"15.0" fill=3D"rgb(222,222,39)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"106.36" y=3D"559.5" ></text>=0A</g>=0A<g >=
=0A<title>netif_receive_skb_list_internal (147,822,297 samples, 0.03%)</tit=
le><rect x=3D"477.3" y=3D"181" width=3D"0.3" height=3D"15.0" fill=3D"rgb(22=
1,95,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"191.5" ></text>=
=0A</g>=0A<g >=0A<title>preempt_count_add (339,757,342 samples, 0.07%)</tit=
le><rect x=3D"186.2" y=3D"565" width=3D"0.8" height=3D"15.0" fill=3D"rgb(23=
8,48,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"189.24" y=3D"575.5" ></text>=
=0A</g>=0A<g >=0A<title>__rcu_read_lock (193,480,350 samples, 0.04%)</title=
><rect x=3D"631.1" y=3D"293" width=3D"0.4" height=3D"15.0" fill=3D"rgb(206,=
23,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"634.09" y=3D"303.5" ></text>=0A<=
/g>=0A<g >=0A<title>exit_to_user_mode_prepare (625,495,838 samples, 0.12%)<=
/title><rect x=3D"1179.0" y=3D"613" width=3D"1.4" height=3D"15.0" fill=3D"r=
gb(215,195,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.99" y=3D"623.5" ></=
text>=0A</g>=0A<g >=0A<title>sched_clock (176,632,775 samples, 0.03%)</titl=
e><rect x=3D"650.3" y=3D"293" width=3D"0.4" height=3D"15.0" fill=3D"rgb(239=
,24,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"653.33" y=3D"303.5" ></text>=0A<=
/g>=0A<g >=0A<title>kvm_vcpu_ioctl (82,977,526 samples, 0.02%)</title><rect=
 x=3D"10.3" y=3D"597" width=3D"0.2" height=3D"15.0" fill=3D"rgb(245,0,26)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"607.5" ></text>=0A</g>=0A<g =
>=0A<title>__smp_call_single_queue (265,057,106 samples, 0.05%)</title><rec=
t x=3D"432.7" y=3D"277" width=3D"0.6" height=3D"15.0" fill=3D"rgb(216,114,4=
2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"435.66" y=3D"287.5" ></text>=0A</g>=
=0A<g >=0A<title>do_syscall_64 (82,977,526 samples, 0.02%)</title><rect x=
=3D"10.3" y=3D"629" width=3D"0.2" height=3D"15.0" fill=3D"rgb(239,183,27)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"639.5" ></text>=0A</g>=0A<g =
>=0A<title>__wake_up_common_lock (36,475,921,393 samples, 7.00%)</title><re=
ct x=3D"21.6" y=3D"581" width=3D"82.6" height=3D"15.0" fill=3D"rgb(239,221,=
48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"24.56" y=3D"591.5" >__wake_up..</te=
xt>=0A</g>=0A<g >=0A<title>__rcu_read_lock (258,005,654 samples, 0.05%)</ti=
tle><rect x=3D"164.6" y=3D"581" width=3D"0.5" height=3D"15.0" fill=3D"rgb(2=
50,162,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.56" y=3D"591.5" ></text>=
=0A</g>=0A<g >=0A<title>[kvm-intel.ko] (5,418,191,303 samples, 1.04%)</titl=
e><rect x=3D"234.9" y=3D"677" width=3D"12.3" height=3D"15.0" fill=3D"rgb(24=
0,85,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"237.93" y=3D"687.5" ></text>=
=0A</g>=0A<g >=0A<title>irq_exit_rcu (440,580,524 samples, 0.08%)</title><r=
ect x=3D"1082.1" y=3D"517" width=3D"1.0" height=3D"15.0" fill=3D"rgb(244,14=
7,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1085.06" y=3D"527.5" ></text>=0A<=
/g>=0A<g >=0A<title>switch_fpu_return (3,548,293,361 samples, 0.68%)</title=
><rect x=3D"1159.0" y=3D"613" width=3D"8.1" height=3D"15.0" fill=3D"rgb(237=
,143,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1162.04" y=3D"623.5" ></text>=
=0A</g>=0A<g >=0A<title>check_preemption_disabled (54,108,994 samples, 0.01=
%)</title><rect x=3D"435.5" y=3D"277" width=3D"0.1" height=3D"15.0" fill=3D=
"rgb(225,88,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"438.46" y=3D"287.5" ></t=
ext>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (665,793,677 samples,=
 0.13%)</title><rect x=3D"192.6" y=3D"629" width=3D"1.5" height=3D"15.0" fi=
ll=3D"rgb(223,76,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"195.64" y=3D"639.5=
" ></text>=0A</g>=0A<g >=0A<title>ip_mc_validate_source (147,822,297 sample=
s, 0.03%)</title><rect x=3D"477.3" y=3D"85" width=3D"0.3" height=3D"15.0" f=
ill=3D"rgb(233,106,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"95.=
5" ></text>=0A</g>=0A<g >=0A<title>__pthread_disable_asynccancel (330,666,3=
36 samples, 0.06%)</title><rect x=3D"201.9" y=3D"677" width=3D"0.8" height=
=3D"15.0" fill=3D"rgb(229,99,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"204.95=
" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>common_interrupt (147,822,297=
 samples, 0.03%)</title><rect x=3D"477.3" y=3D"293" width=3D"0.3" height=3D=
"15.0" fill=3D"rgb(247,151,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=
=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock (1,129,322,005 =
samples, 0.22%)</title><rect x=3D"1067.0" y=3D"549" width=3D"2.6" height=3D=
"15.0" fill=3D"rgb(238,50,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1070.04" =
y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>kvm_wait_lapic_expire (211,990,=
837 samples, 0.04%)</title><rect x=3D"803.6" y=3D"565" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(220,7,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"806.65"=
 y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_call_function_single =
(570,637,537 samples, 0.11%)</title><rect x=3D"1080.1" y=3D"517" width=3D"1=
.3" height=3D"15.0" fill=3D"rgb(216,157,42)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"1083.13" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_apic_timer=
_interrupt (218,927,022 samples, 0.04%)</title><rect x=3D"483.5" y=3D"277" =
width=3D"0.5" height=3D"15.0" fill=3D"rgb(236,142,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"486.47" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>reweight=
_entity (588,816,991 samples, 0.11%)</title><rect x=3D"451.7" y=3D"293" wid=
th=3D"1.4" height=3D"15.0" fill=3D"rgb(207,62,35)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"454.73" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>migrate_page=
s (366,968,562 samples, 0.07%)</title><rect x=3D"662.4" y=3D"421" width=3D"=
0.8" height=3D"15.0" fill=3D"rgb(208,19,27)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"665.37" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>__flush_smp_call_f=
unction_queue (591,929,801 samples, 0.11%)</title><rect x=3D"480.8" y=3D"26=
1" width=3D"1.4" height=3D"15.0" fill=3D"rgb(237,143,14)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"483.83" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__cgr=
oup_account_cputime (270,461,772 samples, 0.05%)</title><rect x=3D"1090.8" =
y=3D"437" width=3D"0.6" height=3D"15.0" fill=3D"rgb(233,36,13)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1093.77" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<titl=
e>[unknown] (97,306,678 samples, 0.02%)</title><rect x=3D"10.0" y=3D"613" w=
idth=3D"0.2" height=3D"15.0" fill=3D"rgb(234,4,19)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"13.00" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_un=
lock (220,920,390 samples, 0.04%)</title><rect x=3D"187.6" y=3D"581" width=
=3D"0.5" height=3D"15.0" fill=3D"rgb(231,135,22)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"190.57" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__napi_poll (=
147,822,297 samples, 0.03%)</title><rect x=3D"477.3" y=3D"229" width=3D"0.3=
" height=3D"15.0" fill=3D"rgb(210,130,24)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"480.30" y=3D"239.5" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (=
323,541,691 samples, 0.06%)</title><rect x=3D"407.3" y=3D"293" width=3D"0.7=
" height=3D"15.0" fill=3D"rgb(253,42,13)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"410.26" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (19=
2,854,750 samples, 0.04%)</title><rect x=3D"82.7" y=3D"485" width=3D"0.4" h=
eight=3D"15.0" fill=3D"rgb(245,156,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
85.70" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>psi_group_change (175,12=
5,212 samples, 0.03%)</title><rect x=3D"431.9" y=3D"261" width=3D"0.4" heig=
ht=3D"15.0" fill=3D"rgb(247,129,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434=
.86" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>file_has_perm (2,662,834,4=
56 samples, 0.51%)</title><rect x=3D"169.8" y=3D"581" width=3D"6.0" height=
=3D"15.0" fill=3D"rgb(251,114,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"172.8=
1" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__pollwait (668,253,353 samp=
les, 0.13%)</title><rect x=3D"965.3" y=3D"597" width=3D"1.5" height=3D"15.0=
" fill=3D"rgb(242,25,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"968.30" y=3D"6=
07.5" ></text>=0A</g>=0A<g >=0A<title>__wake_userfault (38,259,145,251 samp=
les, 7.34%)</title><rect x=3D"21.1" y=3D"597" width=3D"86.6" height=3D"15.0=
" fill=3D"rgb(212,184,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"24.08" y=3D"6=
07.5" >__wake_use..</text>=0A</g>=0A<g >=0A<title>do_syscall_64 (292,015,25=
5,083 samples, 56.05%)</title><rect x=3D"247.5" y=3D"661" width=3D"661.3" h=
eight=3D"15.0" fill=3D"rgb(220,212,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"2=
50.45" y=3D"671.5" >do_syscall_64</text>=0A</g>=0A<g >=0A<title>update_bloc=
ked_averages (796,727,989 samples, 0.15%)</title><rect x=3D"636.5" y=3D"293=
" width=3D"1.8" height=3D"15.0" fill=3D"rgb(209,75,45)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"639.52" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>reweigh=
t_entity (212,608,324 samples, 0.04%)</title><rect x=3D"90.3" y=3D"485" wid=
th=3D"0.5" height=3D"15.0" fill=3D"rgb(216,166,4)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"93.35" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>mmu_try_to_un=
sync_pages (534,999,516 samples, 0.10%)</title><rect x=3D"725.7" y=3D"501" =
width=3D"1.3" height=3D"15.0" fill=3D"rgb(247,184,20)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"728.75" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__mod_lr=
uvec_state (89,505,589 samples, 0.02%)</title><rect x=3D"701.6" y=3D"453" w=
idth=3D"0.2" height=3D"15.0" fill=3D"rgb(226,157,3)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"704.63" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_=
interrupt (200,976,249 samples, 0.04%)</title><rect x=3D"1153.0" y=3D"581" =
width=3D"0.4" height=3D"15.0" fill=3D"rgb(218,150,13)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1155.95" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__x2api=
c_send_IPI_dest (665,336,532 samples, 0.13%)</title><rect x=3D"97.0" y=3D"5=
01" width=3D"1.5" height=3D"15.0" fill=3D"rgb(251,222,37)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"100.02" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>enqu=
eue_entity (493,616,072 samples, 0.09%)</title><rect x=3D"1090.8" y=3D"469"=
 width=3D"1.1" height=3D"15.0" fill=3D"rgb(229,57,45)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"1093.77" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>fput (5=
4,708,976 samples, 0.01%)</title><rect x=3D"973.2" y=3D"597" width=3D"0.1" =
height=3D"15.0" fill=3D"rgb(240,104,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D=
"976.17" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>cgroup_rstat_updated (=
344,869,619 samples, 0.07%)</title><rect x=3D"364.5" y=3D"437" width=3D"0.7=
" height=3D"15.0" fill=3D"rgb(216,98,37)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"367.47" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>update_process_time=
s (979,887,867 samples, 0.19%)</title><rect x=3D"477.8" y=3D"197" width=3D"=
2.3" height=3D"15.0" fill=3D"rgb(205,59,40)" rx=3D"2" ry=3D"2" />=0A<text  =
x=3D"480.84" y=3D"207.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (=
1,119,050,307 samples, 0.21%)</title><rect x=3D"86.0" y=3D"453" width=3D"2.=
5" height=3D"15.0" fill=3D"rgb(218,227,46)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"88.96" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>in_lock_functions (1=
21,167,821 samples, 0.02%)</title><rect x=3D"268.5" y=3D"565" width=3D"0.2"=
 height=3D"15.0" fill=3D"rgb(231,168,14)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"271.48" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__mmu_notifier_inva=
lidate_range_start (408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=
=3D"549" width=3D"0.9" height=3D"15.0" fill=3D"rgb(229,88,34)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1170.07" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<titl=
e>update_rq_clock (1,542,219,934 samples, 0.30%)</title><rect x=3D"653.1" y=
=3D"325" width=3D"3.5" height=3D"15.0" fill=3D"rgb(245,159,35)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"656.06" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title=
>clockevents_program_event (482,909,447 samples, 0.09%)</title><rect x=3D"1=
076.9" y=3D"485" width=3D"1.1" height=3D"15.0" fill=3D"rgb(217,65,12)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1079.90" y=3D"495.5" ></text>=0A</g>=0A<g =
>=0A<title>do_raw_spin_lock (317,797,841 samples, 0.06%)</title><rect x=3D"=
992.7" y=3D"549" width=3D"0.7" height=3D"15.0" fill=3D"rgb(214,24,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"995.67" y=3D"559.5" ></text>=0A</g>=0A<g >=
=0A<title>move_to_new_folio (149,022,958 samples, 0.03%)</title><rect x=3D"=
662.4" y=3D"389" width=3D"0.3" height=3D"15.0" fill=3D"rgb(209,229,51)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"665.41" y=3D"399.5" ></text>=0A</g>=0A<g >=
=0A<title>__flush_smp_call_function_queue (45,175,111 samples, 0.01%)</titl=
e><rect x=3D"440.5" y=3D"309" width=3D"0.1" height=3D"15.0" fill=3D"rgb(225=
,59,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"443.51" y=3D"319.5" ></text>=0A=
</g>=0A<g >=0A<title>tick_sched_timer (265,842,308 samples, 0.05%)</title><=
rect x=3D"107.7" y=3D"501" width=3D"0.6" height=3D"15.0" fill=3D"rgb(213,18=
,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"511.5" ></text>=0A</g>=
=0A<g >=0A<title>rcu_qs (225,058,056 samples, 0.04%)</title><rect x=3D"794.=
7" y=3D"533" width=3D"0.5" height=3D"15.0" fill=3D"rgb(226,160,19)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"797.72" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__cond_resched (138,788,839 samples, 0.03%)</title><rect x=3D"289.9" y=
=3D"501" width=3D"0.4" height=3D"15.0" fill=3D"rgb(251,65,19)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"292.95" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title=
>__intel_pmu_enable_all.constprop.49 (510,454,056 samples, 0.10%)</title><r=
ect x=3D"474.5" y=3D"293" width=3D"1.2" height=3D"15.0" fill=3D"rgb(254,194=
,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"477.54" y=3D"303.5" ></text>=0A</g=
>=0A<g >=0A<title>kvm_slot_page_track_is_active (178,639,548 samples, 0.03%=
)</title><rect x=3D"726.6" y=3D"485" width=3D"0.4" height=3D"15.0" fill=3D"=
rgb(242,109,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"729.56" y=3D"495.5" ></=
text>=0A</g>=0A<g >=0A<title>__mmu_notifier_invalidate_range_start (133,589=
,906 samples, 0.03%)</title><rect x=3D"806.0" y=3D"517" width=3D"0.3" heigh=
t=3D"15.0" fill=3D"rgb(253,55,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05=
" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_notifier_invalidate_r=
ange_start (46,889,230 samples, 0.01%)</title><rect x=3D"141.5" y=3D"517" w=
idth=3D"0.1" height=3D"15.0" fill=3D"rgb(243,210,16)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"144.49" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>vmx_hand=
le_exit (205,894,839,288 samples, 39.52%)</title><rect x=3D"274.6" y=3D"581=
" width=3D"466.3" height=3D"15.0" fill=3D"rgb(217,203,2)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"277.58" y=3D"591.5" >vmx_handle_exit</text>=0A</g>=0A<g >=
=0A<title>idle_cpu (182,704,004 samples, 0.04%)</title><rect x=3D"185.1" y=
=3D"501" width=3D"0.4" height=3D"15.0" fill=3D"rgb(249,187,32)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"188.10" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title=
>do_raw_spin_unlock (164,849,804 samples, 0.03%)</title><rect x=3D"439.7" y=
=3D"325" width=3D"0.3" height=3D"15.0" fill=3D"rgb(248,188,11)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"442.68" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title=
>find_vma (4,715,190,162 samples, 0.90%)</title><rect x=3D"856.4" y=3D"597"=
 width=3D"10.7" height=3D"15.0" fill=3D"rgb(223,156,1)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"859.41" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>migrate=
_task_rq_fair (3,494,246,261 samples, 0.67%)</title><rect x=3D"81.1" y=3D"5=
01" width=3D"7.9" height=3D"15.0" fill=3D"rgb(250,59,3)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"84.07" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>update_=
load_avg (247,280,979 samples, 0.05%)</title><rect x=3D"89.8" y=3D"469" wid=
th=3D"0.5" height=3D"15.0" fill=3D"rgb(233,52,39)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"92.79" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title>task_work_run=
 (625,495,838 samples, 0.12%)</title><rect x=3D"1179.0" y=3D"597" width=3D"=
1.4" height=3D"15.0" fill=3D"rgb(207,5,45)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"1181.99" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>__x86_indirect_thu=
nk_array (608,625,464 samples, 0.12%)</title><rect x=3D"918.1" y=3D"677" wi=
dth=3D"1.4" height=3D"15.0" fill=3D"rgb(207,190,31)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"921.11" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spi=
n_unlock_irqrestore (62,387,637 samples, 0.01%)</title><rect x=3D"104.0" y=
=3D"565" width=3D"0.2" height=3D"15.0" fill=3D"rgb(235,188,32)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"107.03" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title=
>workingset_activation (3,668,442,303 samples, 0.70%)</title><rect x=3D"706=
.6" y=3D"501" width=3D"8.3" height=3D"15.0" fill=3D"rgb(214,12,7)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"709.58" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>folio_mark_accessed (8,225,372,086 samples, 1.58%)</title><rect x=3D"69=
6.3" y=3D"517" width=3D"18.6" height=3D"15.0" fill=3D"rgb(213,3,11)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"699.26" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<=
title>userfaultfd_ioctl (54,318,214,529 samples, 10.43%)</title><rect x=3D"=
18.0" y=3D"613" width=3D"123.0" height=3D"15.0" fill=3D"rgb(217,187,42)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"20.97" y=3D"623.5" >userfaultfd_ioctl</tex=
t>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (1,717,904,155 samples, 0.33%)</=
title><rect x=3D"975.4" y=3D"565" width=3D"3.9" height=3D"15.0" fill=3D"rgb=
(218,27,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"978.41" y=3D"575.5" ></text>=
=0A</g>=0A<g >=0A<title>__filemap_get_folio (4,085,969,992 samples, 0.78%)<=
/title><rect x=3D"379.1" y=3D"373" width=3D"9.2" height=3D"15.0" fill=3D"rg=
b(218,80,54)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"382.08" y=3D"383.5" ></tex=
t>=0A</g>=0A<g >=0A<title>do_syscall_64 (625,495,838 samples, 0.12%)</title=
><rect x=3D"1179.0" y=3D"645" width=3D"1.4" height=3D"15.0" fill=3D"rgb(221=
,110,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1181.99" y=3D"655.5" ></text>=
=0A</g>=0A<g >=0A<title>dequeue_entity (157,093,661 samples, 0.03%)</title>=
<rect x=3D"1091.9" y=3D"501" width=3D"0.3" height=3D"15.0" fill=3D"rgb(247,=
28,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1094.89" y=3D"511.5" ></text>=0A=
</g>=0A<g >=0A<title>[kvm-intel.ko] (19,178,466,220 samples, 3.68%)</title>=
<rect x=3D"751.8" y=3D"565" width=3D"43.4" height=3D"15.0" fill=3D"rgb(245,=
125,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"754.79" y=3D"575.5" >[kvm..</te=
xt>=0A</g>=0A<g >=0A<title>update_process_times (265,842,308 samples, 0.05%=
)</title><rect x=3D"107.7" y=3D"469" width=3D"0.6" height=3D"15.0" fill=3D"=
rgb(249,27,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"479.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__perf_event_task_sched_in (1,372,461,052 sampl=
es, 0.26%)</title><rect x=3D"474.1" y=3D"309" width=3D"3.1" height=3D"15.0"=
 fill=3D"rgb(226,203,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"477.08" y=3D"3=
19.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_call_function_single (214,723,=
398 samples, 0.04%)</title><rect x=3D"108.4" y=3D"565" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(222,41,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.40=
" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>timespec_elapsed (990,141,164=
 samples, 0.19%)</title><rect x=3D"232.6" y=3D"677" width=3D"2.3" height=3D=
"15.0" fill=3D"rgb(232,176,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"235.63" =
y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>clock_gettime@GLIBC_2.2.5 (746,=
593,349 samples, 0.14%)</title><rect x=3D"1183.3" y=3D"693" width=3D"1.6" h=
eight=3D"15.0" fill=3D"rgb(232,222,30)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
1186.26" y=3D"703.5" ></text>=0A</g>=0A<g >=0A<title>_nl_C_LC_CTYPE_tolower=
 (1,884,833,454 samples, 0.36%)</title><rect x=3D"1179.0" y=3D"693" width=
=3D"4.3" height=3D"15.0" fill=3D"rgb(254,175,49)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1181.99" y=3D"703.5" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_re=
ad (395,803,774 samples, 0.08%)</title><rect x=3D"160.2" y=3D"629" width=3D=
"0.9" height=3D"15.0" fill=3D"rgb(211,212,41)" rx=3D"2" ry=3D"2" />=0A<text=
  x=3D"163.23" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run_qu=
eues (265,842,308 samples, 0.05%)</title><rect x=3D"107.7" y=3D"517" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(248,24,47)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"110.74" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>raw_spin_rq_lo=
ck_nested.constprop.116 (5,605,786,372 samples, 1.08%)</title><rect x=3D"36=
.6" y=3D"517" width=3D"12.7" height=3D"15.0" fill=3D"rgb(225,36,37)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"39.56" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__mod_lruvec_state (380,825,855 samples, 0.07%)</title><rect x=3D"1182=
.2" y=3D"453" width=3D"0.9" height=3D"15.0" fill=3D"rgb(224,12,42)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"1185.25" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<=
title>migrate_misplaced_page (366,968,562 samples, 0.07%)</title><rect x=3D=
"662.4" y=3D"437" width=3D"0.8" height=3D"15.0" fill=3D"rgb(239,65,34)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"665.37" y=3D"447.5" ></text>=0A</g>=0A<g >=
=0A<title>restore_fpregs_from_fpstate (328,702,700 samples, 0.06%)</title><=
rect x=3D"270.5" y=3D"565" width=3D"0.7" height=3D"15.0" fill=3D"rgb(247,15=
0,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"273.48" y=3D"575.5" ></text>=0A</g=
>=0A<g >=0A<title>mem_cgroup_from_task (553,217,358 samples, 0.11%)</title>=
<rect x=3D"664.9" y=3D"453" width=3D"1.2" height=3D"15.0" fill=3D"rgb(251,2=
25,28)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"667.86" y=3D"463.5" ></text>=0A<=
/g>=0A<g >=0A<title>__flush_smp_call_function_queue (214,723,398 samples, 0=
.04%)</title><rect x=3D"108.4" y=3D"533" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(216,163,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"111.40" y=3D"543.5" =
></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (66,941,631 samples, 0.01%=
)</title><rect x=3D"652.6" y=3D"309" width=3D"0.2" height=3D"15.0" fill=3D"=
rgb(233,66,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"655.63" y=3D"319.5" ></t=
ext>=0A</g>=0A<g >=0A<title>tlb_flush_mmu (300,782,942 samples, 0.06%)</tit=
le><rect x=3D"1180.4" y=3D"533" width=3D"0.7" height=3D"15.0" fill=3D"rgb(2=
14,127,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"543.5" ></text>=
=0A</g>=0A<g >=0A<title>__sysvec_call_function_single (166,489,982 samples,=
 0.03%)</title><rect x=3D"439.3" y=3D"293" width=3D"0.4" height=3D"15.0" fi=
ll=3D"rgb(211,114,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.30" y=3D"303.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_pfn_to_refcounted_page (554,371,666 =
samples, 0.11%)</title><rect x=3D"715.2" y=3D"517" width=3D"1.3" height=3D"=
15.0" fill=3D"rgb(253,84,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"718.23" y=
=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>kvm_unmap_gfn_range (46,889,230 =
samples, 0.01%)</title><rect x=3D"141.5" y=3D"501" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(211,159,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.49" y=
=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>do_syscall_64 (16,301,481,397 sa=
mples, 3.13%)</title><rect x=3D"159.3" y=3D"645" width=3D"36.9" height=3D"1=
5.0" fill=3D"rgb(243,137,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"162.27" y=
=3D"655.5" >do_..</text>=0A</g>=0A<g >=0A<title>preempt_count_add (239,807,=
166 samples, 0.05%)</title><rect x=3D"1017.9" y=3D"501" width=3D"0.5" heigh=
t=3D"15.0" fill=3D"rgb(205,121,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1020=
.88" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_sl=
owpath (367,560,339 samples, 0.07%)</title><rect x=3D"1167.2" y=3D"421" wid=
th=3D"0.8" height=3D"15.0" fill=3D"rgb(207,93,41)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1170.17" y=3D"431.5" ></text>=0A</g>=0A<g >=0A<title>psi_flags_c=
hange (549,506,247 samples, 0.11%)</title><rect x=3D"1107.2" y=3D"549" widt=
h=3D"1.2" height=3D"15.0" fill=3D"rgb(208,30,1)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"1110.19" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_ap=
ic_timer_interrupt (219,805,393 samples, 0.04%)</title><rect x=3D"970.9" y=
=3D"581" width=3D"0.5" height=3D"15.0" fill=3D"rgb(228,145,9)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"973.94" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>__sysvec_apic_timer_interrupt (265,842,308 samples, 0.05%)</title><rect x=
=3D"107.7" y=3D"549" width=3D"0.6" height=3D"15.0" fill=3D"rgb(237,118,35)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.74" y=3D"559.5" ></text>=0A</g>=0A<=
g >=0A<title>__audit_syscall_entry (336,884,778 samples, 0.06%)</title><rec=
t x=3D"908.0" y=3D"629" width=3D"0.8" height=3D"15.0" fill=3D"rgb(220,208,8=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"911.01" y=3D"639.5" ></text>=0A</g>=
=0A<g >=0A<title>native_sched_clock (193,588,350 samples, 0.04%)</title><re=
ct x=3D"88.5" y=3D"469" width=3D"0.5" height=3D"15.0" fill=3D"rgb(236,106,2=
6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.54" y=3D"479.5" ></text>=0A</g>=
=0A<g >=0A<title>send_call_function_single_ipi (196,338,707 samples, 0.04%)=
</title><rect x=3D"435.7" y=3D"277" width=3D"0.5" height=3D"15.0" fill=3D"r=
gb(237,65,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"438.73" y=3D"287.5" ></te=
xt>=0A</g>=0A<g >=0A<title>do_sys_poll (99,263,813,934 samples, 19.05%)</ti=
tle><rect x=3D"928.1" y=3D"629" width=3D"224.9" height=3D"15.0" fill=3D"rgb=
(213,150,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"931.15" y=3D"639.5" >do_sy=
s_poll</text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (329,468,309 samples,=
 0.06%)</title><rect x=3D"430.1" y=3D"229" width=3D"0.8" height=3D"15.0" fi=
ll=3D"rgb(215,116,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"433.13" y=3D"239.=
5" ></text>=0A</g>=0A<g >=0A<title>update_cfs_rq_h_load (1,611,270,373 samp=
les, 0.31%)</title><rect x=3D"73.2" y=3D"501" width=3D"3.6" height=3D"15.0"=
 fill=3D"rgb(217,111,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"76.18" y=3D"51=
1.5" ></text>=0A</g>=0A<g >=0A<title>psi_task_change (173,876,831 samples, =
0.03%)</title><rect x=3D"632.9" y=3D"245" width=3D"0.4" height=3D"15.0" fil=
l=3D"rgb(253,37,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"635.91" y=3D"255.5"=
 ></text>=0A</g>=0A<g >=0A<title>fib_table_lookup (147,822,297 samples, 0.0=
3%)</title><rect x=3D"477.3" y=3D"37" width=3D"0.3" height=3D"15.0" fill=3D=
"rgb(206,20,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"47.5" ></te=
xt>=0A</g>=0A<g >=0A<title>update_min_vruntime (497,346,023 samples, 0.10%)=
</title><rect x=3D"1020.8" y=3D"517" width=3D"1.2" height=3D"15.0" fill=3D"=
rgb(213,218,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1023.84" y=3D"527.5" ><=
/text>=0A</g>=0A<g >=0A<title>cgroup_rstat_updated (459,353,057 samples, 0.=
09%)</title><rect x=3D"1018.4" y=3D"501" width=3D"1.1" height=3D"15.0" fill=
=3D"rgb(207,138,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1021.44" y=3D"511.5=
" ></text>=0A</g>=0A<g >=0A<title>pollwake (14,384,094,833 samples, 2.76%)<=
/title><rect x=3D"404.8" y=3D"325" width=3D"32.6" height=3D"15.0" fill=3D"r=
gb(225,176,1)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"407.84" y=3D"335.5" >po..=
</text>=0A</g>=0A<g >=0A<title>mtree_load (915,090,812 samples, 0.18%)</tit=
le><rect x=3D"684.9" y=3D"501" width=3D"2.1" height=3D"15.0" fill=3D"rgb(22=
8,87,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"687.92" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (1,750,520,178 samples, 0.34=
%)</title><rect x=3D"84.6" y=3D"469" width=3D"3.9" height=3D"15.0" fill=3D"=
rgb(214,40,43)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"87.58" y=3D"479.5" ></te=
xt>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode_prepare (641,899,537 s=
amples, 0.12%)</title><rect x=3D"192.7" y=3D"613" width=3D"1.4" height=3D"1=
5.0" fill=3D"rgb(205,90,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"195.69" y=
=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_single =
(219,722,202 samples, 0.04%)</title><rect x=3D"108.4" y=3D"581" width=3D"0.=
5" height=3D"15.0" fill=3D"rgb(214,222,17)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"111.39" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>kvm_arch_vcpu_ioctl=
_run (243,866,017,812 samples, 46.80%)</title><rect x=3D"254.1" y=3D"613" w=
idth=3D"552.3" height=3D"15.0" fill=3D"rgb(217,212,1)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"257.08" y=3D"623.5" >kvm_arch_vcpu_ioctl_run</text>=0A</g>=
=0A<g >=0A<title>do_raw_spin_lock (463,087,908 samples, 0.09%)</title><rect=
 x=3D"969.2" y=3D"565" width=3D"1.1" height=3D"15.0" fill=3D"rgb(218,210,5)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"972.22" y=3D"575.5" ></text>=0A</g>=0A=
<g >=0A<title>native_write_msr (864,443,122 samples, 0.17%)</title><rect x=
=3D"1156.9" y=3D"581" width=3D"2.0" height=3D"15.0" fill=3D"rgb(205,170,17)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1159.91" y=3D"591.5" ></text>=0A</g>=
=0A<g >=0A<title>native_write_msr_safe (670,699,803 samples, 0.13%)</title>=
<rect x=3D"743.3" y=3D"549" width=3D"1.6" height=3D"15.0" fill=3D"rgb(209,8=
7,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"746.34" y=3D"559.5" ></text>=0A</=
g>=0A<g >=0A<title>kvm_unmap_gfn_range (133,589,906 samples, 0.03%)</title>=
<rect x=3D"806.0" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"rgb(207,1=
99,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"495.5" ></text>=0A<=
/g>=0A<g >=0A<title>preempt_count_sub (95,054,848 samples, 0.02%)</title><r=
ect x=3D"188.1" y=3D"565" width=3D"0.2" height=3D"15.0" fill=3D"rgb(237,200=
,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"191.12" y=3D"575.5" ></text>=0A</g=
>=0A<g >=0A<title>__this_cpu_preempt_check (266,407,117 samples, 0.05%)</ti=
tle><rect x=3D"1060.8" y=3D"533" width=3D"0.6" height=3D"15.0" fill=3D"rgb(=
230,8,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1063.76" y=3D"543.5" ></text>=
=0A</g>=0A<g >=0A<title>scheduler_tick (202,262,693 samples, 0.04%)</title>=
<rect x=3D"332.5" y=3D"277" width=3D"0.5" height=3D"15.0" fill=3D"rgb(232,1=
3,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335.53" y=3D"287.5" ></text>=0A</g=
>=0A<g >=0A<title>restore_regs_and_return_to_kernel (118,383,749 samples, 0=
.02%)</title><rect x=3D"740.6" y=3D"565" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(251,116,50)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"743.61" y=3D"575.5"=
 ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (123,522,383 samples, 0.02=
%)</title><rect x=3D"1087.7" y=3D"533" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(242,210,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1090.72" y=3D"543.5=
" ></text>=0A</g>=0A<g >=0A<title>__x64_sys_ioctl (54,359,721,140 samples, =
10.43%)</title><rect x=3D"17.9" y=3D"629" width=3D"123.1" height=3D"15.0" f=
ill=3D"rgb(208,6,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"20.88" y=3D"639.5" =
>__x64_sys_ioctl</text>=0A</g>=0A<g >=0A<title>asm_sysvec_call_function (15=
1,189,230 samples, 0.03%)</title><rect x=3D"265.9" y=3D"565" width=3D"0.3" =
height=3D"15.0" fill=3D"rgb(251,61,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"=
268.87" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>assert_clock_updated.is=
ra.83 (123,845,922 samples, 0.02%)</title><rect x=3D"629.2" y=3D"309" width=
=3D"0.3" height=3D"15.0" fill=3D"rgb(251,219,24)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"632.19" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>try_to_wake_u=
p (35,247,955,243 samples, 6.76%)</title><rect x=3D"23.5" y=3D"533" width=
=3D"79.8" height=3D"15.0" fill=3D"rgb(223,202,39)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"26.50" y=3D"543.5" >try_to_wa..</text>=0A</g>=0A<g >=0A<title>na=
tive_write_msr (510,454,056 samples, 0.10%)</title><rect x=3D"474.5" y=3D"2=
77" width=3D"1.2" height=3D"15.0" fill=3D"rgb(226,91,16)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"477.54" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>_raw_=
spin_lock (329,586,723 samples, 0.06%)</title><rect x=3D"352.8" y=3D"453" w=
idth=3D"0.7" height=3D"15.0" fill=3D"rgb(239,2,54)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"355.77" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>__sysvec_ca=
ll_function_single (214,723,398 samples, 0.04%)</title><rect x=3D"108.4" y=
=3D"549" width=3D"0.5" height=3D"15.0" fill=3D"rgb(230,20,16)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"111.40" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title=
>kvm_check_request (1,085,632,362 samples, 0.21%)</title><rect x=3D"263.8" =
y=3D"581" width=3D"2.4" height=3D"15.0" fill=3D"rgb(240,223,44)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"266.75" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__audit_syscall_entry (502,958,418 samples, 0.10%)</title><rect x=3D"223.=
6" y=3D"613" width=3D"1.1" height=3D"15.0" fill=3D"rgb(252,174,10)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"226.60" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<t=
itle>__perf_event_task_sched_in (4,268,775,523 samples, 0.82%)</title><rect=
 x=3D"1057.4" y=3D"549" width=3D"9.6" height=3D"15.0" fill=3D"rgb(216,74,14=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1060.37" y=3D"559.5" ></text>=0A</g>=
=0A<g >=0A<title>__list_del_entry_valid (779,465,910 samples, 0.15%)</title=
><rect x=3D"181.9" y=3D"581" width=3D"1.7" height=3D"15.0" fill=3D"rgb(205,=
140,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"184.88" y=3D"591.5" ></text>=0A=
</g>=0A<g >=0A<title>psi_account_irqtime (175,803,179 samples, 0.03%)</titl=
e><rect x=3D"437.0" y=3D"277" width=3D"0.4" height=3D"15.0" fill=3D"rgb(230=
,37,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"439.98" y=3D"287.5" ></text>=0A=
</g>=0A<g >=0A<title>__mod_memcg_lruvec_state (278,618,181 samples, 0.05%)<=
/title><rect x=3D"1180.4" y=3D"501" width=3D"0.6" height=3D"15.0" fill=3D"r=
gb(243,105,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"511.5" ></=
text>=0A</g>=0A<g >=0A<title>set_task_cpu (5,372,057,928 samples, 1.03%)</t=
itle><rect x=3D"76.8" y=3D"517" width=3D"12.2" height=3D"15.0" fill=3D"rgb(=
217,88,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"79.83" y=3D"527.5" ></text>=
=0A</g>=0A<g >=0A<title>llist_add_batch (265,057,106 samples, 0.05%)</title=
><rect x=3D"432.7" y=3D"261" width=3D"0.6" height=3D"15.0" fill=3D"rgb(227,=
82,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"435.66" y=3D"271.5" ></text>=0A<=
/g>=0A<g >=0A<title>_raw_spin_unlock_irqrestore (606,324,385 samples, 0.12%=
)</title><rect x=3D"83.1" y=3D"485" width=3D"1.4" height=3D"15.0" fill=3D"r=
gb(236,184,41)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.14" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__ia32_sys_gettid (2,564,460,681 samples, 0.49%)=
</title><rect x=3D"215.0" y=3D"629" width=3D"5.8" height=3D"15.0" fill=3D"r=
gb(254,113,35)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"217.99" y=3D"639.5" ></t=
ext>=0A</g>=0A<g >=0A<title>page_remove_rmap (425,031,408 samples, 0.08%)</=
title><rect x=3D"1182.2" y=3D"485" width=3D"1.0" height=3D"15.0" fill=3D"rg=
b(248,227,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.20" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>__audit_syscall_exit (297,510,120 samples, 0.06%=
)</title><rect x=3D"142.2" y=3D"597" width=3D"0.7" height=3D"15.0" fill=3D"=
rgb(213,11,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"145.18" y=3D"607.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__put_user_8 (272,820,012 samples, 0.05%)</titl=
e><rect x=3D"20.5" y=3D"597" width=3D"0.6" height=3D"15.0" fill=3D"rgb(206,=
88,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"23.46" y=3D"607.5" ></text>=0A</=
g>=0A<g >=0A<title>kvm_faultin_pfn (180,672,746,448 samples, 34.68%)</title=
><rect x=3D"285.2" y=3D"533" width=3D"409.1" height=3D"15.0" fill=3D"rgb(24=
3,145,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"288.17" y=3D"543.5" >kvm_faul=
tin_pfn</text>=0A</g>=0A<g >=0A<title>enqueue_entity (267,814,980 samples, =
0.05%)</title><rect x=3D"89.7" y=3D"485" width=3D"0.6" height=3D"15.0" fill=
=3D"rgb(229,27,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"92.74" y=3D"495.5" >=
</text>=0A</g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (888,510,018 s=
amples, 0.17%)</title><rect x=3D"615.8" y=3D"213" width=3D"2.0" height=3D"1=
5.0" fill=3D"rgb(212,203,14)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.80" y=
=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>update_curr (1,770,770,404 sampl=
es, 0.34%)</title><rect x=3D"453.4" y=3D"293" width=3D"4.0" height=3D"15.0"=
 fill=3D"rgb(251,30,17)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"456.38" y=3D"30=
3.5" ></text>=0A</g>=0A<g >=0A<title>percpu_counter_add_batch (1,087,223,89=
4 samples, 0.21%)</title><rect x=3D"878.8" y=3D"581" width=3D"2.5" height=
=3D"15.0" fill=3D"rgb(235,216,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"881.8=
2" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__update_idle_core (1,315,79=
9,362 samples, 0.25%)</title><rect x=3D"1101.4" y=3D"533" width=3D"3.0" hei=
ght=3D"15.0" fill=3D"rgb(240,11,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110=
4.41" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>finish_task_switch (71,45=
0,950,786 samples, 13.71%)</title><rect x=3D"466.3" y=3D"325" width=3D"161.=
8" height=3D"15.0" fill=3D"rgb(239,57,35)" rx=3D"2" ry=3D"2" />=0A<text  x=
=3D"469.26" y=3D"335.5" >finish_task_switch</text>=0A</g>=0A<g >=0A<title>f=
ind_extend_vma (5,642,722,664 samples, 1.08%)</title><rect x=3D"320.2" y=3D=
"469" width=3D"12.8" height=3D"15.0" fill=3D"rgb(238,201,12)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"323.21" y=3D"479.5" ></text>=0A</g>=0A<g >=0A<title=
>_raw_spin_lock (633,815,170 samples, 0.12%)</title><rect x=3D"870.9" y=3D"=
581" width=3D"1.4" height=3D"15.0" fill=3D"rgb(229,40,12)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"873.87" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>do_r=
aw_spin_lock (578,002,905 samples, 0.11%)</title><rect x=3D"446.0" y=3D"309=
" width=3D"1.3" height=3D"15.0" fill=3D"rgb(242,166,14)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"449.01" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>check_=
preemption_disabled (167,523,063 samples, 0.03%)</title><rect x=3D"445.6" y=
=3D"309" width=3D"0.4" height=3D"15.0" fill=3D"rgb(253,38,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"448.63" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title=
>raw_spin_rq_lock_nested.constprop.116 (2,297,937,909 samples, 0.44%)</titl=
e><rect x=3D"408.0" y=3D"293" width=3D"5.2" height=3D"15.0" fill=3D"rgb(237=
,152,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"410.99" y=3D"303.5" ></text>=
=0A</g>=0A<g >=0A<title>preempt_count_sub (338,008,960 samples, 0.06%)</tit=
le><rect x=3D"83.7" y=3D"469" width=3D"0.8" height=3D"15.0" fill=3D"rgb(243=
,88,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.75" y=3D"479.5" ></text>=0A<=
/g>=0A<g >=0A<title>__sysvec_apic_timer_interrupt (3,447,862,661 samples, 0=
.66%)</title><rect x=3D"1070.2" y=3D"517" width=3D"7.8" height=3D"15.0" fil=
l=3D"rgb(250,216,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.20" y=3D"527.=
5" ></text>=0A</g>=0A<g >=0A<title>__audit_syscall_exit (318,739,500 sample=
s, 0.06%)</title><rect x=3D"193.4" y=3D"597" width=3D"0.7" height=3D"15.0" =
fill=3D"rgb(219,121,12)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"196.43" y=3D"60=
7.5" ></text>=0A</g>=0A<g >=0A<title>__cond_resched (128,508,340 samples, 0=
.02%)</title><rect x=3D"318.7" y=3D"469" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(232,35,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"321.75" y=3D"479.5" =
></text>=0A</g>=0A<g >=0A<title>x2apic_send_IPI (365,587,674 samples, 0.07%=
)</title><rect x=3D"100.9" y=3D"501" width=3D"0.8" height=3D"15.0" fill=3D"=
rgb(213,24,2)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"103.90" y=3D"511.5" ></te=
xt>=0A</g>=0A<g >=0A<title>[unknown] (49,209,721 samples, 0.01%)</title><re=
ct x=3D"10.0" y=3D"549" width=3D"0.1" height=3D"15.0" fill=3D"rgb(234,22,41=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"559.5" ></text>=0A</g>=0A=
<g >=0A<title>psi_flags_change (114,622,630 samples, 0.02%)</title><rect x=
=3D"640.3" y=3D"309" width=3D"0.3" height=3D"15.0" fill=3D"rgb(248,105,3)" =
rx=3D"2" ry=3D"2" />=0A<text  x=3D"643.35" y=3D"319.5" ></text>=0A</g>=0A<g=
 >=0A<title>_raw_spin_lock_irqsave (329,468,309 samples, 0.06%)</title><rec=
t x=3D"430.1" y=3D"245" width=3D"0.8" height=3D"15.0" fill=3D"rgb(239,77,47=
)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"433.13" y=3D"255.5" ></text>=0A</g>=
=0A<g >=0A<title>put_prev_task_fair (692,148,299 samples, 0.13%)</title><re=
ct x=3D"650.7" y=3D"325" width=3D"1.6" height=3D"15.0" fill=3D"rgb(237,49,2=
9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"653.73" y=3D"335.5" ></text>=0A</g>=
=0A<g >=0A<title>asm_sysvec_apic_timer_interrupt (1,125,951,899 samples, 0.=
22%)</title><rect x=3D"477.6" y=3D"309" width=3D"2.6" height=3D"15.0" fill=
=3D"rgb(222,216,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.64" y=3D"319.5"=
 ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (314,495,540 samples, 0.=
06%)</title><rect x=3D"327.1" y=3D"421" width=3D"0.7" height=3D"15.0" fill=
=3D"rgb(226,100,32)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"330.06" y=3D"431.5"=
 ></text>=0A</g>=0A<g >=0A<title>available_idle_cpu (3,797,602,989 samples,=
 0.73%)</title><rect x=3D"63.4" y=3D"501" width=3D"8.6" height=3D"15.0" fil=
l=3D"rgb(231,222,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"66.38" y=3D"511.5"=
 ></text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (157,093,661 samples, 0.=
03%)</title><rect x=3D"1091.9" y=3D"517" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(217,91,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1094.89" y=3D"527.5" =
></text>=0A</g>=0A<g >=0A<title>sched_clock_cpu (193,588,350 samples, 0.04%=
)</title><rect x=3D"88.5" y=3D"485" width=3D"0.5" height=3D"15.0" fill=3D"r=
gb(231,149,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"91.54" y=3D"495.5" ></te=
xt>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (229,453,327 samples, 0.04%)</t=
itle><rect x=3D"1096.3" y=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb=
(217,174,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1099.32" y=3D"527.5" ></te=
xt>=0A</g>=0A<g >=0A<title>uffd_handler_thread_fn (2,061,484,248 samples, 0=
.40%)</title><rect x=3D"1185.3" y=3D"693" width=3D"4.7" height=3D"15.0" fil=
l=3D"rgb(253,57,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1188.33" y=3D"703.5=
" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_lock_irqsave (174,652,481 sampl=
es, 0.03%)</title><rect x=3D"406.4" y=3D"293" width=3D"0.4" height=3D"15.0"=
 fill=3D"rgb(252,140,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"409.38" y=3D"3=
03.5" ></text>=0A</g>=0A<g >=0A<title>kvm_mmu_page_fault (204,457,543,911 s=
amples, 39.24%)</title><rect x=3D"277.6" y=3D"565" width=3D"463.0" height=
=3D"15.0" fill=3D"rgb(235,166,7)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"280.57=
" y=3D"575.5" >kvm_mmu_page_fault</text>=0A</g>=0A<g >=0A<title>poll_freewa=
it (5,104,246,259 samples, 0.98%)</title><rect x=3D"970.3" y=3D"613" width=
=3D"11.6" height=3D"15.0" fill=3D"rgb(210,209,5)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"973.33" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<title>pmd_none_or_t=
rans_huge_or_clear_bad (480,563,601 samples, 0.09%)</title><rect x=3D"663.3=
" y=3D"437" width=3D"1.1" height=3D"15.0" fill=3D"rgb(236,8,33)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"666.31" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<titl=
e>task_numa_work (46,889,230 samples, 0.01%)</title><rect x=3D"141.5" y=3D"=
581" width=3D"0.1" height=3D"15.0" fill=3D"rgb(235,65,1)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"144.49" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>updat=
e_process_times (58,323,375 samples, 0.01%)</title><rect x=3D"439.1" y=3D"2=
13" width=3D"0.1" height=3D"15.0" fill=3D"rgb(235,68,32)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"442.11" y=3D"223.5" ></text>=0A</g>=0A<g >=0A<title>updat=
e_load_avg (137,916,483 samples, 0.03%)</title><rect x=3D"636.9" y=3D"277" =
width=3D"0.3" height=3D"15.0" fill=3D"rgb(235,116,47)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"639.93" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_re=
ad_unlock (252,008,737 samples, 0.05%)</title><rect x=3D"429.2" y=3D"261" w=
idth=3D"0.5" height=3D"15.0" fill=3D"rgb(244,64,34)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"432.16" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__bitmap=
_and (238,156,022 samples, 0.05%)</title><rect x=3D"59.1" y=3D"501" width=
=3D"0.6" height=3D"15.0" fill=3D"rgb(245,138,2)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"62.12" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>kvm_unmap_gfn_r=
ange (408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=3D"517" width=
=3D"0.9" height=3D"15.0" fill=3D"rgb(219,158,35)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"1170.07" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit=
_to_user_mode_prepare (213,892,901 samples, 0.04%)</title><rect x=3D"222.0"=
 y=3D"613" width=3D"0.5" height=3D"15.0" fill=3D"rgb(248,200,25)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"225.04" y=3D"623.5" ></text>=0A</g>=0A<g >=0A<tit=
le>[unknown] (133,089,944 samples, 0.03%)</title><rect x=3D"10.0" y=3D"645"=
 width=3D"0.3" height=3D"15.0" fill=3D"rgb(250,120,20)" rx=3D"2" ry=3D"2" /=
>=0A<text  x=3D"13.00" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<title>syscall_=
enter_from_user_mode (209,817,212 samples, 0.04%)</title><rect x=3D"1153.0"=
 y=3D"645" width=3D"0.4" height=3D"15.0" fill=3D"rgb(245,185,21)" rx=3D"2" =
ry=3D"2" />=0A<text  x=3D"1155.95" y=3D"655.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>sched_clock_cpu (553,524,784 samples, 0.11%)</title><rect x=3D"98.9" y=
=3D"501" width=3D"1.2" height=3D"15.0" fill=3D"rgb(252,179,6)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"101.85" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title=
>vcpu_enter_guest (82,977,526 samples, 0.02%)</title><rect x=3D"10.3" y=3D"=
565" width=3D"0.2" height=3D"15.0" fill=3D"rgb(222,112,54)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"13.30" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__vm=
x_vcpu_run_flags (563,600,875 samples, 0.11%)</title><rect x=3D"801.1" y=3D=
"565" width=3D"1.3" height=3D"15.0" fill=3D"rgb(242,211,46)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"804.14" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>__=
pagevec_release (423,998,182 samples, 0.08%)</title><rect x=3D"1179.0" y=3D=
"485" width=3D"1.0" height=3D"15.0" fill=3D"rgb(222,66,2)" rx=3D"2" ry=3D"2=
" />=0A<text  x=3D"1181.99" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>tic=
k_sched_handle.isra.21 (2,937,080,680 samples, 0.56%)</title><rect x=3D"107=
0.2" y=3D"453" width=3D"6.7" height=3D"15.0" fill=3D"rgb(252,113,42)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"1073.23" y=3D"463.5" ></text>=0A</g>=0A<g >=
=0A<title>_raw_spin_lock_irqsave (614,683,055 samples, 0.12%)</title><rect =
x=3D"437.4" y=3D"341" width=3D"1.4" height=3D"15.0" fill=3D"rgb(253,185,13)=
" rx=3D"2" ry=3D"2" />=0A<text  x=3D"440.41" y=3D"351.5" ></text>=0A</g>=0A=
<g >=0A<title>native_write_msr (840,540,335 samples, 0.16%)</title><rect x=
=3D"433.6" y=3D"261" width=3D"1.9" height=3D"15.0" fill=3D"rgb(229,199,47)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"436.56" y=3D"271.5" ></text>=0A</g>=0A<=
g >=0A<title>__rcu_read_unlock (129,896,542 samples, 0.02%)</title><rect x=
=3D"165.1" y=3D"581" width=3D"0.3" height=3D"15.0" fill=3D"rgb(239,10,8)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"168.14" y=3D"591.5" ></text>=0A</g>=0A<g =
>=0A<title>set_task_cpu (1,743,195,206 samples, 0.33%)</title><rect x=3D"42=
7.2" y=3D"293" width=3D"4.0" height=3D"15.0" fill=3D"rgb(216,97,32)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"430.21" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<=
title>sysvec_call_function_single (1,559,253,151 samples, 0.30%)</title><re=
ct x=3D"1079.5" y=3D"533" width=3D"3.6" height=3D"15.0" fill=3D"rgb(206,17,=
19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1082.54" y=3D"543.5" ></text>=0A</g=
>=0A<g >=0A<title>vmx_handle_exit_irqoff (158,988,833 samples, 0.03%)</titl=
e><rect x=3D"740.9" y=3D"581" width=3D"0.3" height=3D"15.0" fill=3D"rgb(249=
,179,10)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"743.88" y=3D"591.5" ></text>=
=0A</g>=0A<g >=0A<title>__sysvec_call_function_single (617,690,008 samples,=
 0.12%)</title><rect x=3D"480.8" y=3D"277" width=3D"1.4" height=3D"15.0" fi=
ll=3D"rgb(220,101,38)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"483.81" y=3D"287.=
5" ></text>=0A</g>=0A<g >=0A<title>is_cpu_allowed (164,633,490 samples, 0.0=
3%)</title><rect x=3D"406.9" y=3D"293" width=3D"0.4" height=3D"15.0" fill=
=3D"rgb(243,226,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"409.89" y=3D"303.5"=
 ></text>=0A</g>=0A<g >=0A<title>raw_spin_rq_lock_nested (490,146,337 sampl=
es, 0.09%)</title><rect x=3D"1095.7" y=3D"533" width=3D"1.2" height=3D"15.0=
" fill=3D"rgb(223,207,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1098.75" y=3D=
"543.5" ></text>=0A</g>=0A<g >=0A<title>__list_del_entry_valid (359,241,547=
 samples, 0.07%)</title><rect x=3D"974.2" y=3D"581" width=3D"0.8" height=3D=
"15.0" fill=3D"rgb(215,217,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"977.17" =
y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>enqueue_task_fair (1,042,652,67=
0 samples, 0.20%)</title><rect x=3D"89.0" y=3D"501" width=3D"2.4" height=3D=
"15.0" fill=3D"rgb(224,3,23)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"92.05" y=
=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_irqrestore (582=
,579,215 samples, 0.11%)</title><rect x=3D"34.0" y=3D"517" width=3D"1.3" he=
ight=3D"15.0" fill=3D"rgb(216,113,27)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"3=
7.01" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>all (521,036,641,042 samp=
les, 100%)</title><rect x=3D"10.0" y=3D"725" width=3D"1180.0" height=3D"15.=
0" fill=3D"rgb(247,191,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"=
735.5" ></text>=0A</g>=0A<g >=0A<title>syscall_enter_from_user_mode (231,99=
1,852 samples, 0.04%)</title><rect x=3D"220.8" y=3D"629" width=3D"0.5" heig=
ht=3D"15.0" fill=3D"rgb(246,23,13)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"223.=
79" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>raw_spin_rq_lock_nested.con=
stprop.116 (1,214,147,174 samples, 0.23%)</title><rect x=3D"1130.5" y=3D"56=
5" width=3D"2.7" height=3D"15.0" fill=3D"rgb(220,79,28)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"1133.46" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>kvm_t=
dp_mmu_map (6,684,753,486 samples, 1.28%)</title><rect x=3D"716.5" y=3D"533=
" width=3D"15.1" height=3D"15.0" fill=3D"rgb(245,200,26)" rx=3D"2" ry=3D"2"=
 />=0A<text  x=3D"719.49" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>check=
_preemption_disabled (202,377,341 samples, 0.04%)</title><rect x=3D"1133.7"=
 y=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(246,52,26)" rx=3D"2" r=
y=3D"2" />=0A<text  x=3D"1136.74" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<tit=
le>entry_SYSCALL_64 (1,259,337,616 samples, 0.24%)</title><rect x=3D"1180.4=
" y=3D"661" width=3D"2.9" height=3D"15.0" fill=3D"rgb(233,128,16)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"1183.41" y=3D"671.5" ></text>=0A</g>=0A<g >=0A<t=
itle>preempt_count_sub (107,584,152 samples, 0.02%)</title><rect x=3D"706.3=
" y=3D"485" width=3D"0.3" height=3D"15.0" fill=3D"rgb(225,149,18)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"709.34" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>ksys_read (13,915,168,064 samples, 2.67%)</title><rect x=3D"161.1" y=3D=
"629" width=3D"31.5" height=3D"15.0" fill=3D"rgb(249,169,23)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"164.13" y=3D"639.5" >ks..</text>=0A</g>=0A<g >=0A<t=
itle>sched_clock_cpu (155,248,012 samples, 0.03%)</title><rect x=3D"655.7" =
y=3D"293" width=3D"0.4" height=3D"15.0" fill=3D"rgb(215,146,8)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"658.75" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title=
>_raw_spin_unlock (148,790,845 samples, 0.03%)</title><rect x=3D"478.5" y=
=3D"149" width=3D"0.3" height=3D"15.0" fill=3D"rgb(230,35,6)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"481.50" y=3D"159.5" ></text>=0A</g>=0A<g >=0A<title=
>vmx_vcpu_load_vmcs (60,348,935,405 samples, 11.58%)</title><rect x=3D"484.=
9" y=3D"277" width=3D"136.7" height=3D"15.0" fill=3D"rgb(225,104,18)" rx=3D=
"2" ry=3D"2" />=0A<text  x=3D"487.89" y=3D"287.5" >vmx_vcpu_load_vmcs</text=
>=0A</g>=0A<g >=0A<title>psi_account_irqtime (1,269,158,812 samples, 0.24%)=
</title><rect x=3D"653.2" y=3D"309" width=3D"2.9" height=3D"15.0" fill=3D"r=
gb(210,10,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"656.22" y=3D"319.5" ></tex=
t>=0A</g>=0A<g >=0A<title>change_prot_numa (46,889,230 samples, 0.01%)</tit=
le><rect x=3D"141.5" y=3D"565" width=3D"0.1" height=3D"15.0" fill=3D"rgb(20=
5,46,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"144.49" y=3D"575.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_spin_unlock (256,691,874 samples, 0.05%)</ti=
tle><rect x=3D"83.2" y=3D"469" width=3D"0.5" height=3D"15.0" fill=3D"rgb(24=
6,224,44)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"86.17" y=3D"479.5" ></text>=
=0A</g>=0A<g >=0A<title>__count_memcg_events (1,259,827,782 samples, 0.24%)=
</title><rect x=3D"363.2" y=3D"453" width=3D"2.8" height=3D"15.0" fill=3D"r=
gb(205,216,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"366.19" y=3D"463.5" ></t=
ext>=0A</g>=0A<g >=0A<title>__kvm_mmu_topup_memory_cache (389,105,849 sampl=
es, 0.07%)</title><rect x=3D"732.1" y=3D"517" width=3D"0.9" height=3D"15.0"=
 fill=3D"rgb(206,155,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"735.08" y=3D"5=
27.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (471,210,034 samples=
, 0.09%)</title><rect x=3D"1132.1" y=3D"549" width=3D"1.1" height=3D"15.0" =
fill=3D"rgb(211,40,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1135.12" y=3D"559=
.5" ></text>=0A</g>=0A<g >=0A<title>psi_group_change (7,519,269,573 samples=
, 1.44%)</title><rect x=3D"1108.4" y=3D"549" width=3D"17.1" height=3D"15.0"=
 fill=3D"rgb(219,121,42)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1111.44" y=3D"=
559.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_timer (58,323,375 samples=
, 0.01%)</title><rect x=3D"439.1" y=3D"245" width=3D"0.1" height=3D"15.0" f=
ill=3D"rgb(230,71,11)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.11" y=3D"255.=
5" ></text>=0A</g>=0A<g >=0A<title>folio_activate (4,452,592,807 samples, 0=
.85%)</title><rect x=3D"696.5" y=3D"501" width=3D"10.1" height=3D"15.0" fil=
l=3D"rgb(207,113,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"699.50" y=3D"511.5=
" ></text>=0A</g>=0A<g >=0A<title>clock_gettime@GLIBC_2.2.5 (656,662,395 sa=
mples, 0.13%)</title><rect x=3D"207.8" y=3D"661" width=3D"1.5" height=3D"15=
.0" fill=3D"rgb(235,64,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"210.79" y=3D=
"671.5" ></text>=0A</g>=0A<g >=0A<title>__vdso_clock_gettime (215,218,346 s=
amples, 0.04%)</title><rect x=3D"204.5" y=3D"677" width=3D"0.5" height=3D"1=
5.0" fill=3D"rgb(244,173,47)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"207.47" y=
=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>handle_ept_violation (772,673,62=
3 samples, 0.15%)</title><rect x=3D"275.8" y=3D"565" width=3D"1.8" height=
=3D"15.0" fill=3D"rgb(248,28,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"278.82"=
 y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>unmap_page_range (958,554,674 =
samples, 0.18%)</title><rect x=3D"1181.1" y=3D"533" width=3D"2.2" height=3D=
"15.0" fill=3D"rgb(231,174,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1184.09"=
 y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (58,323,375 =
samples, 0.01%)</title><rect x=3D"439.1" y=3D"277" width=3D"0.1" height=3D"=
15.0" fill=3D"rgb(244,89,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.11" y=
=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>find_vma (5,012,754,485 samples,=
 0.96%)</title><rect x=3D"321.6" y=3D"453" width=3D"11.4" height=3D"15.0" f=
ill=3D"rgb(237,105,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"324.63" y=3D"463.=
5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (274,355,526 samples, =
0.05%)</title><rect x=3D"173.9" y=3D"549" width=3D"0.6" height=3D"15.0" fil=
l=3D"rgb(218,206,45)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"176.92" y=3D"559.5=
" ></text>=0A</g>=0A<g >=0A<title>preempt_count_add (52,904,099 samples, 0.=
01%)</title><rect x=3D"292.0" y=3D"485" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(226,102,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"294.98" y=3D"495.5" =
></text>=0A</g>=0A<g >=0A<title>put_prev_entity (891,719,993 samples, 0.17%=
)</title><rect x=3D"1128.4" y=3D"549" width=3D"2.1" height=3D"15.0" fill=3D=
"rgb(252,23,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1131.44" y=3D"559.5" ></=
text>=0A</g>=0A<g >=0A<title>hrtimer_interrupt (875,695,984 samples, 0.17%)=
</title><rect x=3D"615.8" y=3D"197" width=3D"2.0" height=3D"15.0" fill=3D"r=
gb(246,61,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.83" y=3D"207.5" ></te=
xt>=0A</g>=0A<g >=0A<title>native_sched_clock (289,503,534 samples, 0.06%)<=
/title><rect x=3D"98.9" y=3D"485" width=3D"0.7" height=3D"15.0" fill=3D"rgb=
(229,113,39)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"101.91" y=3D"495.5" ></tex=
t>=0A</g>=0A<g >=0A<title>select_task_rq_fair (12,172,947,422 samples, 2.34=
%)</title><rect x=3D"49.3" y=3D"517" width=3D"27.5" height=3D"15.0" fill=3D=
"rgb(241,38,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"52.26" y=3D"527.5" >s..=
</text>=0A</g>=0A<g >=0A<title>sysvec_call_function_single (166,489,982 sam=
ples, 0.03%)</title><rect x=3D"439.3" y=3D"309" width=3D"0.4" height=3D"15.=
0" fill=3D"rgb(230,208,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"442.30" y=3D=
"319.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_write_lock (95,928,137 sampl=
es, 0.02%)</title><rect x=3D"806.0" y=3D"421" width=3D"0.3" height=3D"15.0"=
 fill=3D"rgb(242,172,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"4=
31.5" ></text>=0A</g>=0A<g >=0A<title>record_times (549,331,813 samples, 0.=
11%)</title><rect x=3D"1124.2" y=3D"533" width=3D"1.3" height=3D"15.0" fill=
=3D"rgb(205,186,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1127.22" y=3D"543.5=
" ></text>=0A</g>=0A<g >=0A<title>dequeue_entity (6,523,173,633 samples, 1.=
25%)</title><rect x=3D"450.8" y=3D"309" width=3D"14.8" height=3D"15.0" fill=
=3D"rgb(252,45,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"453.80" y=3D"319.5" =
></text>=0A</g>=0A<g >=0A<title>security_file_permission (5,512,552,789 sam=
ples, 1.06%)</title><rect x=3D"167.2" y=3D"597" width=3D"12.5" height=3D"15=
.0" fill=3D"rgb(224,185,8)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"170.21" y=3D=
"607.5" ></text>=0A</g>=0A<g >=0A<title>__mod_node_page_state (380,825,855 =
samples, 0.07%)</title><rect x=3D"1182.2" y=3D"437" width=3D"0.9" height=3D=
"15.0" fill=3D"rgb(247,52,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1185.25" =
y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>pick_next_task_idle (661,384,24=
0 samples, 0.13%)</title><rect x=3D"638.6" y=3D"325" width=3D"1.5" height=
=3D"15.0" fill=3D"rgb(246,104,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"641.6=
3" y=3D"335.5" ></text>=0A</g>=0A<g >=0A<title>[unknown] (133,089,944 sampl=
es, 0.03%)</title><rect x=3D"10.0" y=3D"661" width=3D"0.3" height=3D"15.0" =
fill=3D"rgb(227,163,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.00" y=3D"671=
.5" ></text>=0A</g>=0A<g >=0A<title>tick_sched_handle.isra.21 (866,787,999 =
samples, 0.17%)</title><rect x=3D"615.8" y=3D"149" width=3D"2.0" height=3D"=
15.0" fill=3D"rgb(235,215,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.85" y=
=3D"159.5" ></text>=0A</g>=0A<g >=0A<title>check_preemption_disabled (315,1=
20,784 samples, 0.06%)</title><rect x=3D"1134.2" y=3D"533" width=3D"0.7" he=
ight=3D"15.0" fill=3D"rgb(243,141,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"11=
37.20" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>enqueue_task_fair (130,9=
25,091 samples, 0.03%)</title><rect x=3D"431.2" y=3D"277" width=3D"0.3" hei=
ght=3D"15.0" fill=3D"rgb(235,120,0)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"434=
.17" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>update_load_avg (206,748,0=
85 samples, 0.04%)</title><rect x=3D"1036.2" y=3D"549" width=3D"0.5" height=
=3D"15.0" fill=3D"rgb(217,167,33)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1039.=
25" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>up_read (2,015,376,196 samp=
les, 0.39%)</title><rect x=3D"656.6" y=3D"357" width=3D"4.5" height=3D"15.0=
" fill=3D"rgb(245,56,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"659.55" y=3D"3=
67.5" ></text>=0A</g>=0A<g >=0A<title>syscall_exit_to_user_mode (533,364,81=
9 samples, 0.10%)</title><rect x=3D"221.3" y=3D"629" width=3D"1.2" height=
=3D"15.0" fill=3D"rgb(231,54,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"224.32=
" y=3D"639.5" ></text>=0A</g>=0A<g >=0A<title>udp_v4_early_demux (147,822,2=
97 samples, 0.03%)</title><rect x=3D"477.3" y=3D"101" width=3D"0.3" height=
=3D"15.0" fill=3D"rgb(235,69,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30=
" y=3D"111.5" ></text>=0A</g>=0A<g >=0A<title>update_rq_clock (703,184,209 =
samples, 0.13%)</title><rect x=3D"101.7" y=3D"517" width=3D"1.6" height=3D"=
15.0" fill=3D"rgb(249,189,19)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"104.73" y=
=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>pmd_huge (126,433,186 samples, 0=
.02%)</title><rect x=3D"309.1" y=3D"453" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(205,19,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"312.05" y=3D"463.5" =
></text>=0A</g>=0A<g >=0A<title>down_read (809,804,854 samples, 0.16%)</tit=
le><rect x=3D"290.3" y=3D"501" width=3D"1.8" height=3D"15.0" fill=3D"rgb(24=
8,104,22)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"293.26" y=3D"511.5" ></text>=
=0A</g>=0A<g >=0A<title>do_raw_write_lock (408,075,530 samples, 0.08%)</tit=
le><rect x=3D"1167.1" y=3D"453" width=3D"0.9" height=3D"15.0" fill=3D"rgb(2=
50,92,36)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1170.07" y=3D"463.5" ></text>=
=0A</g>=0A<g >=0A<title>change_protection (133,589,906 samples, 0.03%)</tit=
le><rect x=3D"806.0" y=3D"533" width=3D"0.3" height=3D"15.0" fill=3D"rgb(20=
6,10,5)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"809.05" y=3D"543.5" ></text>=0A=
</g>=0A<g >=0A<title>sysvec_apic_timer_interrupt (3,655,374,848 samples, 0.=
70%)</title><rect x=3D"1070.2" y=3D"533" width=3D"8.3" height=3D"15.0" fill=
=3D"rgb(246,193,51)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1073.20" y=3D"543.5=
" ></text>=0A</g>=0A<g >=0A<title>__check_object_size (614,646,039 samples,=
 0.12%)</title><rect x=3D"940.7" y=3D"613" width=3D"1.4" height=3D"15.0" fi=
ll=3D"rgb(209,124,25)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"943.70" y=3D"623.=
5" ></text>=0A</g>=0A<g >=0A<title>kvm_vcpu_gfn_to_memslot (319,843,798 sam=
ples, 0.06%)</title><rect x=3D"739.9" y=3D"549" width=3D"0.7" height=3D"15.=
0" fill=3D"rgb(224,118,21)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"742.88" y=3D=
"559.5" ></text>=0A</g>=0A<g >=0A<title>shmem_get_folio_gfp (125,308,974,50=
7 samples, 24.05%)</title><rect x=3D"378.6" y=3D"389" width=3D"283.8" heigh=
t=3D"15.0" fill=3D"rgb(241,51,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"381.5=
8" y=3D"399.5" >shmem_get_folio_gfp</text>=0A</g>=0A<g >=0A<title>reweight_=
entity (321,978,180 samples, 0.06%)</title><rect x=3D"1007.7" y=3D"533" wid=
th=3D"0.7" height=3D"15.0" fill=3D"rgb(217,199,9)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"1010.70" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>sysvec_call=
_function_single (258,005,654 samples, 0.05%)</title><rect x=3D"164.6" y=3D=
"549" width=3D"0.5" height=3D"15.0" fill=3D"rgb(208,175,14)" rx=3D"2" ry=3D=
"2" />=0A<text  x=3D"167.56" y=3D"559.5" ></text>=0A</g>=0A<g >=0A<title>sm=
p_call_function_many_cond (181,644,572 samples, 0.03%)</title><rect x=3D"66=
2.8" y=3D"341" width=3D"0.4" height=3D"15.0" fill=3D"rgb(220,25,7)" rx=3D"2=
" ry=3D"2" />=0A<text  x=3D"665.79" y=3D"351.5" ></text>=0A</g>=0A<g >=0A<t=
itle>filemap_unaccount_folio (66,534,568 samples, 0.01%)</title><rect x=3D"=
1180.1" y=3D"437" width=3D"0.2" height=3D"15.0" fill=3D"rgb(245,156,14)" rx=
=3D"2" ry=3D"2" />=0A<text  x=3D"1183.11" y=3D"447.5" ></text>=0A</g>=0A<g =
>=0A<title>check_preemption_disabled (363,595,813 samples, 0.07%)</title><r=
ect x=3D"698.1" y=3D"453" width=3D"0.8" height=3D"15.0" fill=3D"rgb(245,156=
,20)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"701.12" y=3D"463.5" ></text>=0A</g=
>=0A<g >=0A<title>check_preemption_disabled (74,248,866 samples, 0.01%)</ti=
tle><rect x=3D"263.6" y=3D"581" width=3D"0.2" height=3D"15.0" fill=3D"rgb(2=
39,109,15)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"266.58" y=3D"591.5" ></text>=
=0A</g>=0A<g >=0A<title>handle_mm_fault (134,702,619,492 samples, 25.85%)</=
title><rect x=3D"361.1" y=3D"469" width=3D"305.0" height=3D"15.0" fill=3D"r=
gb(228,72,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"364.05" y=3D"479.5" >handl=
e_mm_fault</text>=0A</g>=0A<g >=0A<title>__GI___ioctl (82,977,526 samples, =
0.02%)</title><rect x=3D"10.3" y=3D"661" width=3D"0.2" height=3D"15.0" fill=
=3D"rgb(239,77,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"13.30" y=3D"671.5" >=
</text>=0A</g>=0A<g >=0A<title>vmx_prepare_switch_to_guest (2,893,815,732 s=
amples, 0.56%)</title><rect x=3D"741.2" y=3D"581" width=3D"6.6" height=3D"1=
5.0" fill=3D"rgb(230,69,16)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"744.24" y=
=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__kvm_migrate_timers (158,739,78=
1 samples, 0.03%)</title><rect x=3D"260.1" y=3D"581" width=3D"0.4" height=
=3D"15.0" fill=3D"rgb(224,163,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"263.1=
2" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>add_wait_queue (583,371,782 =
samples, 0.11%)</title><rect x=3D"189.7" y=3D"581" width=3D"1.3" height=3D"=
15.0" fill=3D"rgb(249,191,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"192.66" y=
=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>perf_event_task_tick (265,842,30=
8 samples, 0.05%)</title><rect x=3D"107.7" y=3D"437" width=3D"0.6" height=
=3D"15.0" fill=3D"rgb(248,145,48)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"110.7=
4" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<title>native_queued_spin_lock_slow=
path (2,297,937,909 samples, 0.44%)</title><rect x=3D"408.0" y=3D"261" widt=
h=3D"5.2" height=3D"15.0" fill=3D"rgb(246,23,37)" rx=3D"2" ry=3D"2" />=0A<t=
ext  x=3D"410.99" y=3D"271.5" ></text>=0A</g>=0A<g >=0A<title>__hrtimer_run=
_queues (192,863,815 samples, 0.04%)</title><rect x=3D"440.1" y=3D"293" wid=
th=3D"0.4" height=3D"15.0" fill=3D"rgb(231,165,41)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"443.07" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>__loaded_vm=
cs_clear (197,631,341 samples, 0.04%)</title><rect x=3D"108.4" y=3D"517" wi=
dth=3D"0.4" height=3D"15.0" fill=3D"rgb(223,162,37)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"111.40" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>kvm_dirt=
y_ring_check_request (484,450,621 samples, 0.09%)</title><rect x=3D"266.2" =
y=3D"581" width=3D"1.1" height=3D"15.0" fill=3D"rgb(240,23,43)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"269.21" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>perf_adjust_freq_unthr_context (365,777,872 samples, 0.07%)</title><rect x=
=3D"478.8" y=3D"149" width=3D"0.9" height=3D"15.0" fill=3D"rgb(227,199,44)"=
 rx=3D"2" ry=3D"2" />=0A<text  x=3D"481.85" y=3D"159.5" ></text>=0A</g>=0A<=
g >=0A<title>perf_adjust_freq_unthr_context (703,920,444 samples, 0.14%)</t=
itle><rect x=3D"615.8" y=3D"85" width=3D"1.6" height=3D"15.0" fill=3D"rgb(2=
44,78,18)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"618.85" y=3D"95.5" ></text>=
=0A</g>=0A<g >=0A<title>copy_user_short_string (781,478,974 samples, 0.15%)=
</title><rect x=3D"183.7" y=3D"565" width=3D"1.8" height=3D"15.0" fill=3D"r=
gb(234,162,24)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"186.74" y=3D"575.5" ></t=
ext>=0A</g>=0A<g >=0A<title>check_vma_flags (515,531,441 samples, 0.10%)</t=
itle><rect x=3D"319.0" y=3D"469" width=3D"1.2" height=3D"15.0" fill=3D"rgb(=
207,86,49)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"322.04" y=3D"479.5" ></text>=
=0A</g>=0A<g >=0A<title>asm_sysvec_call_function_single (258,005,654 sample=
s, 0.05%)</title><rect x=3D"164.6" y=3D"565" width=3D"0.5" height=3D"15.0" =
fill=3D"rgb(232,128,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"167.56" y=3D"575=
.5" ></text>=0A</g>=0A<g >=0A<title>__bitmap_andnot (62,864,040 samples, 0.=
01%)</title><rect x=3D"59.7" y=3D"501" width=3D"0.1" height=3D"15.0" fill=
=3D"rgb(208,219,34)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"62.66" y=3D"511.5" =
></text>=0A</g>=0A<g >=0A<title>do_raw_read_lock (1,222,809,060 samples, 0.=
23%)</title><rect x=3D"281.2" y=3D"533" width=3D"2.8" height=3D"15.0" fill=
=3D"rgb(206,124,4)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"284.23" y=3D"543.5" =
></text>=0A</g>=0A<g >=0A<title>__rcu_read_unlock (188,628,277 samples, 0.0=
4%)</title><rect x=3D"814.2" y=3D"581" width=3D"0.5" height=3D"15.0" fill=
=3D"rgb(253,44,40)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"817.24" y=3D"591.5" =
></text>=0A</g>=0A<g >=0A<title>__libc_disable_asynccancel (1,231,988,728 s=
amples, 0.24%)</title><rect x=3D"908.8" y=3D"693" width=3D"2.8" height=3D"1=
5.0" fill=3D"rgb(224,128,31)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"911.81" y=
=3D"703.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_lock (176,531,028 sam=
ples, 0.03%)</title><rect x=3D"956.1" y=3D"597" width=3D"0.4" height=3D"15.=
0" fill=3D"rgb(231,36,9)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"959.07" y=3D"6=
07.5" ></text>=0A</g>=0A<g >=0A<title>native_sched_clock (923,905,287 sampl=
es, 0.18%)</title><rect x=3D"1125.9" y=3D"533" width=3D"2.1" height=3D"15.0=
" fill=3D"rgb(237,204,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1128.87" y=3D=
"543.5" ></text>=0A</g>=0A<g >=0A<title>dequeue_task_fair (15,666,169,559 s=
amples, 3.01%)</title><rect x=3D"1001.2" y=3D"565" width=3D"35.5" height=3D=
"15.0" fill=3D"rgb(245,101,37)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1004.24"=
 y=3D"575.5" >deq..</text>=0A</g>=0A<g >=0A<title>check_preemption_disabled=
 (278,142,360 samples, 0.05%)</title><rect x=3D"1081.4" y=3D"517" width=3D"=
0.7" height=3D"15.0" fill=3D"rgb(221,191,32)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1084.43" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>shmem_undo_range=
 (625,495,838 samples, 0.12%)</title><rect x=3D"1179.0" y=3D"501" width=3D"=
1.4" height=3D"15.0" fill=3D"rgb(246,218,26)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"1181.99" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title>__inode_security=
_revalidate (192,471,760 samples, 0.04%)</title><rect x=3D"179.3" y=3D"565"=
 width=3D"0.4" height=3D"15.0" fill=3D"rgb(252,137,2)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"182.26" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_r=
ead_unlock (314,669,801 samples, 0.06%)</title><rect x=3D"280.5" y=3D"517" =
width=3D"0.7" height=3D"15.0" fill=3D"rgb(235,39,9)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"283.52" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<title>preempt_=
count_add (1,356,347,605 samples, 0.26%)</title><rect x=3D"104.2" y=3D"565"=
 width=3D"3.1" height=3D"15.0" fill=3D"rgb(230,75,37)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"107.19" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>_raw_rea=
d_unlock (325,499,965 samples, 0.06%)</title><rect x=3D"280.5" y=3D"533" wi=
dth=3D"0.7" height=3D"15.0" fill=3D"rgb(241,183,34)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"283.50" y=3D"543.5" ></text>=0A</g>=0A<g >=0A<title>mtree_ra=
nge_walk (2,801,977,462 samples, 0.54%)</title><rect x=3D"860.7" y=3D"565" =
width=3D"6.4" height=3D"15.0" fill=3D"rgb(232,218,31)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"863.75" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>vmx_pass=
through_lbr_msrs (513,948,171 samples, 0.10%)</title><rect x=3D"804.9" y=3D=
"565" width=3D"1.1" height=3D"15.0" fill=3D"rgb(226,70,24)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"807.87" y=3D"575.5" ></text>=0A</g>=0A<g >=0A<title>psi=
_group_change (523,021,486 samples, 0.10%)</title><rect x=3D"91.5" y=3D"485=
" width=3D"1.2" height=3D"15.0" fill=3D"rgb(239,6,17)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"94.47" y=3D"495.5" ></text>=0A</g>=0A<g >=0A<title>intel_pmu=
_disable_all (192,619,122 samples, 0.04%)</title><rect x=3D"447.3" y=3D"309=
" width=3D"0.5" height=3D"15.0" fill=3D"rgb(254,170,10)" rx=3D"2" ry=3D"2" =
/>=0A<text  x=3D"450.32" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<title>__cond=
_resched (141,351,469 samples, 0.03%)</title><rect x=3D"140.6" y=3D"581" wi=
dth=3D"0.4" height=3D"15.0" fill=3D"rgb(218,60,14)" rx=3D"2" ry=3D"2" />=0A=
<text  x=3D"143.65" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title>__rcu_read_=
unlock (302,600,153 samples, 0.06%)</title><rect x=3D"631.5" y=3D"293" widt=
h=3D"0.7" height=3D"15.0" fill=3D"rgb(212,109,19)" rx=3D"2" ry=3D"2" />=0A<=
text  x=3D"634.52" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<title>_raw_spin_un=
lock (783,291,148 samples, 0.15%)</title><rect x=3D"353.5" y=3D"453" width=
=3D"1.8" height=3D"15.0" fill=3D"rgb(240,43,27)" rx=3D"2" ry=3D"2" />=0A<te=
xt  x=3D"356.52" y=3D"463.5" ></text>=0A</g>=0A<g >=0A<title>update_rq_cloc=
k (475,929,076 samples, 0.09%)</title><rect x=3D"637.2" y=3D"277" width=3D"=
1.1" height=3D"15.0" fill=3D"rgb(205,156,33)" rx=3D"2" ry=3D"2" />=0A<text =
 x=3D"640.24" y=3D"287.5" ></text>=0A</g>=0A<g >=0A<title>kvm_service_local=
_tlb_flush_requests (339,483,575 samples, 0.07%)</title><rect x=3D"267.3" y=
=3D"581" width=3D"0.8" height=3D"15.0" fill=3D"rgb(240,72,7)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"270.31" y=3D"591.5" ></text>=0A</g>=0A<g >=0A<title=
>update_rq_clock (219,425,190 samples, 0.04%)</title><rect x=3D"1098.7" y=
=3D"517" width=3D"0.5" height=3D"15.0" fill=3D"rgb(216,34,22)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1101.72" y=3D"527.5" ></text>=0A</g>=0A<g >=0A<titl=
e>spte_to_child_pt (235,598,701 samples, 0.05%)</title><rect x=3D"730.2" y=
=3D"501" width=3D"0.5" height=3D"15.0" fill=3D"rgb(205,146,42)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"733.20" y=3D"511.5" ></text>=0A</g>=0A<g >=0A<title=
>__fget_light (1,238,576,300 samples, 0.24%)</title><rect x=3D"162.6" y=3D"=
597" width=3D"2.8" height=3D"15.0" fill=3D"rgb(229,118,51)" rx=3D"2" ry=3D"=
2" />=0A<text  x=3D"165.63" y=3D"607.5" ></text>=0A</g>=0A<g >=0A<title>exi=
t_to_user_mode_prepare (6,027,297,909 samples, 1.16%)</title><rect x=3D"115=
4.9" y=3D"629" width=3D"13.6" height=3D"15.0" fill=3D"rgb(251,29,3)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"1157.90" y=3D"639.5" ></text>=0A</g>=0A<g >=0A=
<title>update_load_avg (3,612,476,578 samples, 0.69%)</title><rect x=3D"457=
.4" y=3D"293" width=3D"8.2" height=3D"15.0" fill=3D"rgb(213,111,26)" rx=3D"=
2" ry=3D"2" />=0A<text  x=3D"460.39" y=3D"303.5" ></text>=0A</g>=0A<g >=0A<=
title>pick_next_entity (125,867,421 samples, 0.02%)</title><rect x=3D"638.3=
" y=3D"309" width=3D"0.3" height=3D"15.0" fill=3D"rgb(216,164,40)" rx=3D"2"=
 ry=3D"2" />=0A<text  x=3D"641.32" y=3D"319.5" ></text>=0A</g>=0A<g >=0A<ti=
tle>__poll (239,755,972 samples, 0.05%)</title><rect x=3D"201.4" y=3D"677" =
width=3D"0.5" height=3D"15.0" fill=3D"rgb(244,204,10)" rx=3D"2" ry=3D"2" />=
=0A<text  x=3D"204.41" y=3D"687.5" ></text>=0A</g>=0A<g >=0A<title>queued_w=
rite_lock_slowpath (408,075,530 samples, 0.08%)</title><rect x=3D"1167.1" y=
=3D"437" width=3D"0.9" height=3D"15.0" fill=3D"rgb(216,14,44)" rx=3D"2" ry=
=3D"2" />=0A<text  x=3D"1170.07" y=3D"447.5" ></text>=0A</g>=0A<g >=0A<titl=
e>__sysvec_apic_timer_interrupt (218,927,022 samples, 0.04%)</title><rect x=
=3D"483.5" y=3D"261" width=3D"0.5" height=3D"15.0" fill=3D"rgb(243,46,8)" r=
x=3D"2" ry=3D"2" />=0A<text  x=3D"486.47" y=3D"271.5" ></text>=0A</g>=0A<g =
>=0A<title>asm_sysvec_call_function_single (192,432,359 samples, 0.04%)</ti=
tle><rect x=3D"388.3" y=3D"373" width=3D"0.5" height=3D"15.0" fill=3D"rgb(2=
14,3,29)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"391.33" y=3D"383.5" ></text>=
=0A</g>=0A<g >=0A<title>update_sd_lb_stats.constprop.137 (1,232,033,093 sam=
ples, 0.24%)</title><rect x=3D"633.3" y=3D"261" width=3D"2.8" height=3D"15.=
0" fill=3D"rgb(248,5,6)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"636.30" y=3D"27=
1.5" ></text>=0A</g>=0A<g >=0A<title>irq_exit_rcu (147,822,297 samples, 0.0=
3%)</title><rect x=3D"477.3" y=3D"277" width=3D"0.3" height=3D"15.0" fill=
=3D"rgb(234,96,3)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"480.30" y=3D"287.5" >=
</text>=0A</g>=0A<g >=0A<title>_raw_spin_unlock_irqrestore (128,946,935 sam=
ples, 0.02%)</title><rect x=3D"429.7" y=3D"261" width=3D"0.3" height=3D"15.=
0" fill=3D"rgb(245,77,52)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"432.74" y=3D"=
271.5" ></text>=0A</g>=0A<g >=0A<title>do_raw_spin_lock (559,804,875 sample=
s, 0.11%)</title><rect x=3D"1094.4" y=3D"501" width=3D"1.3" height=3D"15.0"=
 fill=3D"rgb(247,48,46)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"1097.41" y=3D"5=
11.5" ></text>=0A</g>=0A<g >=0A<title>perf_adjust_freq_unthr_context (202,2=
62,693 samples, 0.04%)</title><rect x=3D"332.5" y=3D"245" width=3D"0.5" hei=
ght=3D"15.0" fill=3D"rgb(230,46,53)" rx=3D"2" ry=3D"2" />=0A<text  x=3D"335=
.53" y=3D"255.5" ></text>=0A</g>=0A</g>=0A</svg>=0A
--Mh1nfu5EYGrCe8FI--

